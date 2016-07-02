//
//  GADBannerViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 7/1/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

#import "GADBannerViewController.h"
@import GoogleMobileAds;
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"

#define kSteamGeniusAdUnitId @"ca-app-pub-3586707060758787/1771896357"
#define kSteamGeniusAdUnitTestId @"ca-app-pub-3940256099942544/2934735716"

#define kSteamGeniusPremiumIdentifier @"com.eriklopez.steamgenius.premium"
#define kSteamGeniusRemoveAdsIdentifier @"com.eriklopez.steamgenius.adremoval"
#define kSteamGeniusCustomFactionIconsIdentifier @"com.eriklopez.steamgenius.customfactionicons"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";
NSString * const BannerViewActionWillLeaveApplication = @"BannerViewActionWillLeaveApplication";

@interface GADBannerViewController () <GADBannerViewDelegate, RMStoreObserver>

@end

@implementation GADBannerViewController {
  GADBannerView *_bannerView;
  UIViewController *_contentController;
  BOOL _adBannerLoaded;
  BOOL _isPremiumPurchased;
  BOOL _isRemoveAdsPurchased;
}

- (instancetype)initWithContentViewController:(UIViewController *)contentController
{
  // Make sure a contentController is set.
  NSAssert(contentController != nil, @"Attempting to initialize a BannerViewController with a nil contentController.");
  
  self = [super init];
  if (self != nil) {
    _isPremiumPurchased = NO;
    _isRemoveAdsPurchased = NO;
    [self checkPurchases];
    [[RMStore defaultStore] addStoreObserver:self];
    
    // Check if portrait and size ads appropriately
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait) {
      _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    } else {
      _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    }
    _bannerView.delegate = self;
    _bannerView.adUnitID = kSteamGeniusAdUnitId;
    _bannerView.rootViewController = self;
    _contentController = contentController;
    
    _bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [_bannerView loadRequest:request];
  }
  return self;
}

- (void)loadView
{
  UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  [contentView addSubview:_bannerView];
  
  // Setup containment of the _contentController.
  [self addChildViewController:_contentController];
  [contentView addSubview:_contentController.view];
  [_contentController didMoveToParentViewController:self];
  
  self.view = contentView;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return [_contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return [_contentController preferredInterfaceOrientationForPresentation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
  return [_contentController supportedInterfaceOrientations];
}

- (void)viewDidLayoutSubviews {
  CGRect contentFrame = self.view.bounds;
  CGRect bannerFrame = CGRectZero;
  
  bannerFrame.size = [_bannerView sizeThatFits:contentFrame.size];
  
  if (_adBannerLoaded) {
    if (_isPremiumPurchased || _isRemoveAdsPurchased) {
      bannerFrame.origin.y = contentFrame.size.height;
    }
    else {
      contentFrame.size.height -= bannerFrame.size.height;
      bannerFrame.origin.y = contentFrame.size.height;
    }
  }
  _contentController.view.frame = contentFrame;
  _bannerView.frame = bannerFrame;
}

- (void)dealloc
{
  [[RMStore defaultStore] removeStoreObserver:self];
}

#pragma mark - GADBannerViewDelegate Methods

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  NSLog(@"adViewDidReceiveAd");
  _adBannerLoaded = YES;
  
  [UIView animateWithDuration:0.25 animations:^{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
  }];
  
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
  _adBannerLoaded = NO;
  
  [UIView animateWithDuration:0.25 animations:^{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
  }];
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
  NSLog(@"adViewWillPresentScreen");
  
  [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
  NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
  NSLog(@"adViewDidDismissScreen");
  
  [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
  NSLog(@"adViewWillLeaveApplication");
  
  [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillLeaveApplication object:self];
}

#pragma mark - RMStoreObserver Methods

- (void)storePaymentTransactionFinished:(NSNotification *)notification
{
  [self applyPurchases];
}

- (void)storeRestoreTransactionsFinished:(NSNotification *)notification
{
  [self applyPurchases];
}

#pragma Private Methods

- (void)checkPurchases
{
  RMStoreKeychainPersistence *persist = [RMStore defaultStore].transactionPersistor;
  NSArray *purchases = [[persist purchasedProductIdentifiers] allObjects];
  _isPremiumPurchased = [purchases containsObject:kSteamGeniusPremiumIdentifier];
  _isRemoveAdsPurchased = [purchases containsObject:kSteamGeniusRemoveAdsIdentifier];
}

- (void)applyPurchases
{
  [self checkPurchases];
  [self.view setNeedsLayout];
  [self.view layoutIfNeeded];
}

@end
