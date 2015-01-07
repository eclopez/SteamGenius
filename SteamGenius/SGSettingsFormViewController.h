//
//  SGSettingsFormViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <iAd/iAd.h>
#import "FXForms.h"

@interface SGSettingsFormViewController : FXFormViewController <ADBannerViewDelegate>

@property (nonatomic) BOOL isBannerVisible;
@property (strong, nonatomic) ADBannerView *adView;

@end