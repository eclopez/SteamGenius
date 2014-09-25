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

- (NSDictionary *)themeField {
    void (^updateTheme)(id) = ^(UITableViewCell<FXFormFieldCell> *sender) {
        [SGSettingsManager updateTheme:[sender.field.value intValue]];
    };
    
    return @{ FXFormFieldHeader: @"Appearance",
              FXFormFieldOptions: [self themes],
              FXFormFieldDefaultValue: [self currentTheme],
              FXFormFieldAction: updateTheme };
}

#pragma mark - Class Methods

- (NSNumber *)currentTheme {
    return [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
}

- (NSArray *)themes {
    return [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"]] valueForKeyPath:@"@unionOfObjects.name"];
}



@end