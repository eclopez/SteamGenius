//
//  SGSettingsForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsForm.h"
#import "SGSettingsManager.h"

@implementation SGSettingsForm

- (NSArray *)fields
{
    NSNumber *currentTheme = [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
    NSArray *themes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"]];
    
    NSMutableArray *themeList = [[NSMutableArray alloc] init];
    for (id theme in themes) {
        [themeList addObject:[NSNumber numberWithInt:[themes indexOfObject:theme]]];
    }
    
    NSString *(^themeValueTransformer)(id) = ^(id value) {
        NSMutableArray *themeNameList = [[NSMutableArray alloc] init];
        for (id theme in themes) {
            [themeNameList addObject:[theme objectForKey:@"name"]];
        }
        return value ? [themeNameList objectAtIndex:[value intValue]] : nil;
    };
    
    void (^updateTheme)(id) = ^(UITableViewCell<FXFormFieldCell> *sender) {
        [SGSettingsManager updateTheme:[sender.field.value intValue]];
    };
    
    return @[@{ FXFormFieldKey: @"theme",
                FXFormFieldHeader: @"Appearance",
                FXFormFieldOptions: themeList,
                FXFormFieldDefaultValue: currentTheme,
                FXFormFieldValueTransformer: themeValueTransformer,
                FXFormFieldAction: updateTheme }];
}

@end