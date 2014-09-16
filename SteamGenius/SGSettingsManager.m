//
//  SGPreferencesManager.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsManager.h"
#import "AppDelegate.h"
#import "SGBattleListViewController.h"

static NSInteger const defaultTheme = 1;

@implementation SGSettingsManager

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
    NSDictionary *defaults = @{ @"theme" : [NSNumber numberWithInt:defaultTheme] };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

+ (void)setGlobalTheme
{
    NSString *themeFile = [[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"];
    NSArray *themes = [NSArray arrayWithContentsOfFile:themeFile];
    NSDictionary *currentTheme = [themes objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
    
    NSDictionary *bar = [currentTheme valueForKey:@"barColor"];
    UIColor *barColor = [UIColor colorWithRed:[[bar valueForKey:@"red"] floatValue]/255.f green:[[bar valueForKey:@"green"] floatValue]/255.f blue:[[bar valueForKey:@"blue"] floatValue]/255.f alpha:[[bar valueForKey:@"alpha"] floatValue]];
    
    NSDictionary *tint = [currentTheme valueForKey:@"tintColor"];
    UIColor *tintColor = [UIColor colorWithRed:[[tint valueForKey:@"red"] floatValue]/255.f green:[[tint valueForKey:@"green"] floatValue]/255.f blue:[[tint valueForKey:@"blue"] floatValue]/255.f alpha:[[tint valueForKey:@"alpha"] floatValue]];
    
    NSDictionary *text = [currentTheme valueForKey:@"textColor"];
    UIColor *textColor = [UIColor colorWithRed:[[text valueForKey:@"red"] floatValue]/255.f green:[[text valueForKey:@"green"] floatValue]/255.f blue:[[text valueForKey:@"blue"] floatValue]/255.f alpha:[[text valueForKey:@"alpha"] floatValue]];
    
    NSDictionary *table = [currentTheme valueForKey:@"tableColor"];
    UIColor *tableColor = [UIColor colorWithRed:[[table valueForKey:@"red"] floatValue]/255.f green:[[table valueForKey:@"green"] floatValue]/255.f blue:[[table valueForKey:@"blue"] floatValue]/255.f alpha:[[table valueForKey:@"alpha"] floatValue]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[[currentTheme valueForKey:@"statusBarStyle"] intValue]];
    
    NSDictionary *navBarAttributes = @{ NSForegroundColorAttributeName : textColor,
                                        NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Bold" size:18.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAttributes];
    [[UINavigationBar appearance] setBarTintColor:barColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    
    [[UIToolbar appearance] setBarTintColor:barColor];
    [[UIToolbar appearance] setTintColor:tintColor];
    
    [[UITableView appearanceWhenContainedIn:[SGBattleListViewController class], nil] setBackgroundColor:tableColor];
}

@end
