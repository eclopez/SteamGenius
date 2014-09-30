//
//  SGPreferencesManager.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SGSettingsManager : NSObject

+ (void)initUserPreferences;
+ (void)updateTheme:(NSInteger)newTheme;

+ (UIColor *)getTableColor;

@end