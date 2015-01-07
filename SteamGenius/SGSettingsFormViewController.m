//
//  SGSettingsFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsFormViewController.h"
#import "SGSettingsForm.h"
#import "SGWebViewController.h"

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD  UIUserInterfaceIdiomPad

@interface SGSettingsFormViewController ()

@end

@implementation SGSettingsFormViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.formController.form = [[SGSettingsForm alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (IDIOM != IPAD) {
        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        _adView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - AdBannerViewDelegate Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_isBannerVisible) {
        if (_adView.superview == nil) {
            [self.tableView.superview addSubview:_adView];
        }
        
        [UIView beginAnimations:@"animateAdViewOn" context:nil];
        
        // Assumes the banner view is just off the bottom of the screen
        _adView.frame = CGRectOffset(banner.frame, 0, -_adView.frame.size.height);
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, _adView.frame.size.height, self.tableView.contentInset.right);
        [UIView commitAnimations];
        _isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Failed to retrieve ad");
}

#pragma mark - Class Methods

- (void)showWebView {
    SGWebViewController *web = [[SGWebViewController alloc] initWithWebFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    web.title = @"Donate";
    [self.navigationController pushViewController:web animated:YES];
}


@end
