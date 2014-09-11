//
//  SGPreferencesManager.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGPreferencesManager.h"
#import "AppDelegate.h"

#define kCygnarBase [UIColor colorWithRed:16.f/255.f green:55.f/255.f blue:136.f/255.f alpha:1]
#define kCygnarTint [UIColor colorWithRed:243.f/255.f green:225.f/255.f blue:36.f/255.f alpha:1]
#define kCygnarTable [UIColor colorWithRed:10.f/255.f green:36.f/255.f blue:89.f/255.f alpha:1]

#define kKhadorBase [UIColor colorWithRed:207.f/255.f green:52.f/255.f blue:53.f/255.f alpha:1]
#define kKhadorTint [UIColor colorWithRed:49.f/255.f green:48.f/255.f blue:50.f/255.f alpha:1]
#define kKhadorTable [UIColor colorWithRed:149.f/255.f green:52.f/255.f blue:53.f/255.f alpha:1]

#define kProtectorateBase
#define kProtectorateTint
#define kProtectorateTable

#define kCryxBase
#define kCryxTint
#define kCryxTable

#define kRetributionBase
#define kRetributionTint
#define kRetributionTable

#define kConvergenceBase
#define kConvergenceTint
#define kConvergenceTable

#define kMercenaryBase
#define kMercenaryTint
#define kMercenaryTable

#define kTrollbloodBase
#define kTrollbloodTint
#define kTrollbloodTable

#define kCircleBase
#define kCircleTint
#define kCircleTable

#define kSkorneBase
#define kSkorneTint
#define kSkorneTable

#define kLegionBase
#define kLegionTint
#define kLegionTable

@implementation SGPreferencesManager

#pragma mark - Public Methods

+ (void)initUserPreferences
{
    [self registerDefaultPreferences];
    [self setGlobalTheme];
}

+ (void)updateTheme:(NSInteger)newTheme
{
    [[NSUserDefaults standardUserDefaults] setInteger:newTheme forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setGlobalTheme];
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

#pragma mark - Private Methods

+ (void)registerDefaultPreferences
{
    NSDictionary *defaults = @{ @"theme" : [NSNumber numberWithInt:SGTheme_Cygnar] };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

+ (void)setGlobalTheme
{
    [self setStatusBarTextColor];
    
    NSDictionary *navBarAttributes = @{ NSForegroundColorAttributeName : [self getBarTextColor],
                                        NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Bold" size:18.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAttributes];
    [[UINavigationBar appearance] setBarTintColor:[self getBarBackgroundColor]];
    [[UINavigationBar appearance] setTintColor:[self getBarTintColor]];
    
    [[UIToolbar appearance] setBarTintColor:[self getBarBackgroundColor]];
    [[UIToolbar appearance] setTintColor:[self getBarTintColor]];
    
    //[[UITableView appearanceWhenContainedIn:[SGBattleListViewController class], nil] setBackgroundColor:[self getTableBackgroundColor]];
}

#pragma mark - Theme Methods

+ (void)setStatusBarTextColor
{
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    
    switch ([theme intValue]) {
        case SGTheme_Cygnar:
        case SGTheme_Khador:
        case SGTheme_Cryx:
        case SGTheme_Convergence:
        case SGTheme_Trollblood:
        case SGTheme_Circle:
        case SGTheme_Skorne:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            break;
        case SGTheme_Protectorate:
        case SGTheme_Retribution:
        case SGTheme_Mercenary:
        case SGTheme_Legion:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

+ (UIColor *)getBarBackgroundColor
{
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    
    switch ([theme intValue]) {
        case SGTheme_Cygnar:
            return kCygnarBase;
            break;
        case SGTheme_Khador:
            return kKhadorBase;
        default:
            return [UIColor lightGrayColor];
            break;
    }
}

+ (UIColor *)getBarTextColor
{
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    
    switch ([theme intValue]) {
        case SGTheme_Cygnar:
        case SGTheme_Khador:
        case SGTheme_Cryx:
        case SGTheme_Convergence:
        case SGTheme_Trollblood:
        case SGTheme_Circle:
        case SGTheme_Skorne:
            return [UIColor whiteColor];
            break;
        case SGTheme_Protectorate:
        case SGTheme_Retribution:
        case SGTheme_Mercenary:
        case SGTheme_Legion:
        default:
            return [UIColor blackColor];
    }
}

+ (UIColor *)getBarTintColor
{
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    
    switch ([theme intValue]) {
        case SGTheme_Cygnar:
            return kCygnarTint;
            break;
        case SGTheme_Khador:
            return kKhadorTint;
        default:
            return [UIColor blackColor];
            break;
    }
}

+ (UIColor *)getTableBackgroundColor
{
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    
    switch ([theme intValue]) {
        case SGTheme_Cygnar:
            return kCygnarTable;
            break;
        case SGTheme_Khador:
            return kKhadorTable;
        default:
            return [UIColor whiteColor];
            break;
    }
}

@end
