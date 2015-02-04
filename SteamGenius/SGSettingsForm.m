//
//  SGSettingsForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsForm.h"
#import "SGSettingsManager.h"
#import "SGProductsTableViewController.h"
#import "SGWebViewController.h"

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

- (NSDictionary *)productsField {
    return @{ FXFormFieldHeader: @"In-App Purchases",
              FXFormFieldType: @"default",
              FXFormFieldTitle: @"SteamGenius Store",
              FXFormFieldViewController: @"SGProductsTableViewController" };
}

- (NSDictionary *)donateField {
    return @{ FXFormFieldHeader: @"Support SteamGenius' development",
              FXFormFieldType: @"default",
              FXFormFieldDefaultValue: @"gofund.me/evep0k",
              FXFormFieldTitle: @"Donate",
              FXFormFieldViewController: @"SGWebViewController" };
}

#pragma mark - Class Methods

- (NSNumber *)currentTheme {
    return [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
}

- (NSArray *)themes {
    return [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"]] valueForKeyPath:@"@unionOfObjects.name"];
}

@end