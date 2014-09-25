//
//  SGBattleForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleForm.h"
#import "AppDelegate.h"
#import "SGGenericRepository.h"
#import "Caster.h"
#import "Model.h"
#import "SGFactionOptionsTableViewController.h"
#import "SGGenericOptionsTableViewController.h"

@implementation SGBattleForm

- (NSDictionary *)playerCasterField {
    return @{ FXFormFieldHeader: @"Player Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: @"SGFactionOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKey:@"name" ascending:NO] };
}

- (NSString *)playerCasterFieldDescription {
    return self.playerCaster ? self.playerCaster.model.name : nil;
}

- (NSDictionary *)opponentCasterField {
    return @{ FXFormFieldHeader: @"Opponent Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: @"SGFactionOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKey:@"name" ascending:NO] };
}

- (NSString *)opponentCasterFieldDescription {
    return self.opponentCaster ? self.opponentCaster.model.name : nil;
}

- (NSDictionary *)opponentField {
    return @{ FXFormFieldViewController: @"SGGenericOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Opponent" sortKey:@"name" ascending:YES]};
}

- (NSDictionary *)dateField {
    return @{ FXFormFieldHeader: @"Required",
              FXFormFieldDefaultValue: [NSDate date]};
}

- (NSDictionary *)pointSizeField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)resultField {
    return @{ FXFormFieldViewController: @"SGGenericOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Result" sortKey:@"name" ascending:YES]};
}

- (NSDictionary *)killPointsField {
    return @{ FXFormFieldHeader: @"Optional",
              FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)scenarioField {
    return @{ FXFormFieldViewController: @"SGGenericOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Scenario" sortKey:@"name" ascending:YES]};
}

- (NSDictionary *)controlPointsField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)eventField {
    return @{ FXFormFieldViewController: @"SGGenericOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Event" sortKey:@"name" ascending:YES]};
}

#pragma mark - Class Methods

- (NSArray *)sortedObjectArray:(NSString *)entityName sortKey:(NSString *)sortKey ascending:(BOOL)ascending {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSSortDescriptor *sort = sortKey ? [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending] : nil;
    return [[SGGenericRepository findAllEntitiesOfType:entityName context:appDelegate.managedObjectContext] sortedArrayUsingDescriptors:@[sort]];
}

@end