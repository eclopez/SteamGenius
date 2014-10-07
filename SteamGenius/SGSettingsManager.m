//
//  SGPreferencesManager.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsManager.h"
#import "AppDelegate.h"

static NSInteger const defaultTheme = 0;

@implementation SGSettingsManager

#pragma mark - Public Methods

+ (void)initUserPreferences {
    [self registerDefaultPreferences];
    [self setGlobalTheme];
}

+ (void)updateTheme:(NSInteger)newTheme {
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

+ (UIColor *)getBarColor {
    NSString *themeFile = [[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"];
    NSArray *themes = [NSArray arrayWithContentsOfFile:themeFile];
    NSDictionary *currentTheme = [themes objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
    
    return [self getColorWithDictionary:[currentTheme valueForKey:@"barColor"]];
}

#pragma mark - Private Methods

+ (void)registerDefaultPreferences {
    NSDictionary *defaults = @{ @"theme" : [NSNumber numberWithInt:defaultTheme] };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

+ (void)setGlobalTheme {
    NSString *themeFile = [[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"];
    NSArray *themes = [NSArray arrayWithContentsOfFile:themeFile];
    NSDictionary *currentTheme = [themes objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
    
    UIColor *barColor = [self getColorWithDictionary:[currentTheme valueForKey:@"barColor"]];
    UIColor *tintColor = [self getColorWithDictionary:[currentTheme valueForKey:@"tintColor"]];
    UIColor *textColor = [self getColorWithDictionary:[currentTheme valueForKey:@"textColor"]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[[currentTheme valueForKey:@"statusBarStyle"] intValue]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: textColor, NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Bold" size:18.f]}];
    [[UINavigationBar appearance] setBarTintColor:barColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    
    [[UIToolbar appearance] setBarTintColor:barColor];
    [[UIToolbar appearance] setTintColor:tintColor];
}

+ (UIColor *)getColorWithDictionary:(NSDictionary *)colorDictionary {
    return [UIColor colorWithRed:[[colorDictionary valueForKey:@"red"] floatValue]/255.f
                           green:[[colorDictionary valueForKey:@"green"] floatValue]/255.f
                            blue:[[colorDictionary valueForKey:@"blue"] floatValue]/255.f
                           alpha:[[colorDictionary valueForKey:@"alpha"] floatValue]];
}

@end
