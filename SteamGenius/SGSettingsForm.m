//
//  SGSettingsForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsForm.h"
#import "AppDelegate.h"
#import "SGSettingsManager.h"
#import "SGProductsTableViewController.h"
#import "SGWebViewController.h"
#import "SGFactionsOptionTableViewController.h"
#import "SGFactionIconsViewController.h"
#import "RMStoreKeychainPersistence.h"

#define kSteamGeniusPremiumIdentifier @"com.eriklopez.steamgenius.premium"
#define kSteamGeniusCustomFactionIconsIdentifier @"com.eriklopez.steamgenius.customfactionicons"

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

- (NSDictionary *)factionIconsField {
    return @{ FXFormFieldTitle: @"Faction Icons",
              FXFormFieldType: @"image",
              FXFormFieldViewController: [[SGFactionsOptionTableViewController alloc] init:^(UINavigationController *navController, FXFormField *field, Faction *faction){
                  SGFactionIconsViewController *factionIconsPickerViewController = [[SGFactionIconsViewController alloc] init];
                  factionIconsPickerViewController.faction = faction;
                  factionIconsPickerViewController.navController = navController;
                  [navController presentViewController:factionIconsPickerViewController animated:YES completion:nil];
              }],
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }] };;
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

- (NSArray *)fields
{
    RMStoreKeychainPersistence *persist = [RMStore defaultStore].transactionPersistor;
    NSArray *purchases = [[persist purchasedProductIdentifiers] allObjects];
    if ([purchases containsObject:kSteamGeniusPremiumIdentifier] || [purchases containsObject:kSteamGeniusCustomFactionIconsIdentifier]) {
        return @[ @"theme", @"factionIcons", @"products", @"donate" ];
    } else {
        return @[ @"theme", @"products", @"donate" ];
    }
}

#pragma mark - Class Methods

- (NSNumber *)currentTheme {
    return [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] intValue]];
}

- (NSArray *)themes {
    return [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"]] valueForKeyPath:@"@unionOfObjects.name"];
}

- (NSArray *)sortedObjectArray:(NSString *)entityName sortKeys:(NSDictionary *)sortKeys {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (id sortKey in sortKeys) {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:[[sortKeys objectForKey:sortKey] boolValue]]];
    }
    return [[SGKRepository findAllEntitiesOfType:entityName predicate:nil context:appDelegate.managedObjectContext] sortedArrayUsingDescriptors:sortDescriptors];
}

@end