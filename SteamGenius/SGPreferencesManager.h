//
//  SGPreferencesManager.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGTheme){
    SGTheme_Cygnar,
    SGTheme_Khador,
    SGTheme_Protectorate,
    SGTheme_Cryx,
    SGTheme_Retribution,
    SGTheme_Convergence,
    SGTheme_Mercenary,
    SGTheme_Trollblood,
    SGTheme_Circle,
    SGTheme_Skorne,
    SGTheme_Legion
};

@interface SGPreferencesManager : NSObject

+ (void)initUserPreferences;
+ (void)updateTheme:(NSInteger)newTheme;

@end
