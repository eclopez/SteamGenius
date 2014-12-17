//
//  SGFilterListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFilterListViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface SGFilterListViewController () <GADBannerViewDelegate>

@end

@implementation SGFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:];
    _bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50.f);
    _bannerView.adUnitID = @"ca-app-pub-8879373581005349/3911408297";
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    [self.view addSubview:_bannerView];
    
    GADRequest *request = [GADRequest request];
    // Enable test ads on simulators.
    request.testDevices = @[ GAD_SIMULATOR_ID, @"27ddf9aef2a33235182aaba0454a2138" ];
    [_bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GADBannerView Delegate Methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"Got ad.");
    if ([self.view.subviews containsObject:_bannerView]) {
        NSLog(@"Already got one.");
    }
    [UIView animateWithDuration:0.5 animations:^{
        _bannerView.frame = CGRectMake(0.0,
                                self.view.frame.size.height - _bannerView.frame.size.height,
                                _bannerView.frame.size.width,
                                _bannerView.frame.size.height);
    }];
    /*[self.view addSubview:_bannerView];
    [UIView beginAnimations:@"BannerSlide" context:nil];
    _bannerView.frame = CGRectMake(0.0,
                                       self.view.frame.size.height -
                                       _bannerView.frame.size.height,
                                       _bannerView.frame.size.width,
                                       _bannerView.frame.size.height);
    [UIView commitAnimations];*/
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Didn't got ad.");
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"Will present ad.");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"Will un present ad.");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"Will dismiss ad.");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"Will leave your app.");
}

- (void)dealloc {
    NSLog(@"Is this even hit?");
    _bannerView.delegate = nil;
    _bannerView = nil;
}

@end
