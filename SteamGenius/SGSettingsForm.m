//
//  SGSettingsForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsForm.h"
#import "ThemeValueTransformer.h"

@implementation SGSettingsForm

- (NSArray *)fields
{
    NSNumber *currentTheme = [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
    NSString *themeFile = [[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"];
    NSArray *themes = [NSArray arrayWithContentsOfFile:themeFile];
    
    NSMutableArray *themeList = [[NSMutableArray alloc] init];
    for (id theme in themes) {
        [themeList addObject:[NSNumber numberWithInt:[themes indexOfObject:theme]]];
    }
    
    return @[@{ FXFormFieldKey: @"theme",
                FXFormFieldHeader: @"Appearance",
                FXFormFieldOptions: themeList,
                FXFormFieldDefaultValue: currentTheme,
                FXFormFieldValueTransformer: [[ThemeValueTransformer alloc] init] }];
}

@end