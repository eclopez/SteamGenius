//
//  SGFiltersListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/5/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFiltersListViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface SGFiltersListViewController () <GADBannerViewDelegate>

@end

@implementation SGFiltersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.backgroundColor = [UIColor blackColor];
    
    self.bannerView.adUnitID = @"ca-app-pub-8879373581005349/3911408297";
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ GAD_SIMULATOR_ID, @"27ddf9aef2a33235182aaba0454a2138" ];
    [self.bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GADBannerView Delegate

/// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    
    if ([_bannerView isKindOfClass:[GADBannerView class]]) {
        // The AdMob banner ads scroll vertically if you drag your finger across them and it looks lame.
        // This disables that.
        [self preventGADBannerViewBounceScrolling:(GADBannerView *) _bannerView];
    }
}
 
 /// Called when an ad request failed.
 - (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
 NSLog(@"adViewDidFailToReceiveAdWithError: %@", [error localizedDescription]);
 }
 
 /// Called just before presenting the user a full screen view, such as
 /// a browser, in response to clicking on an ad.
 - (void)adViewWillPresentScreen:(GADBannerView *)adView {
 NSLog(@"adViewWillPresentScreen");
 }
 
 /// Called just before dismissing a full screen view.
 - (void)adViewWillDismissScreen:(GADBannerView *)adView {
 NSLog(@"adViewWillDismissScreen");
 }
 
 /// Called just after dismissing a full screen view.
 - (void)adViewDidDismissScreen:(GADBannerView *)adView {
 NSLog(@"adViewDidDismissScreen");
 }
 
 /// Called just before the application will background or terminate
 /// because the user clicked on an ad that will launch another
 /// application (such as the App Store).
 - (void)adViewWillLeaveApplication:(GADBannerView *)adView {
 NSLog(@"adViewDidLeaveApplication");
 }

- (void)preventGADBannerViewBounceScrolling:(GADBannerView*)bannerView {
    /*for (UIWebView *webView in bannerView.subviews) {
        if ([webView isKindOfClass:[UIWebView class]]) {
            webView.scrollView.scrollEnabled = NO;
        }
    }*/
}

@end
