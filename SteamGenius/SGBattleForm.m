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
#import "Result.h"
#import "SGFactionOptionsTableViewController.h"
#import "SGGenericAddOptionsTableViewController.h"
#import "SGGenericOptionsTableViewController.h"

@implementation SGBattleForm

- (NSDictionary *)playerCasterField {
    return @{ FXFormFieldHeader: @"Player Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: @"SGFactionOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }] };
}

- (NSString *)playerCasterFieldDescription {
    return self.playerCaster ? self.playerCaster.model.name : nil;
}

- (NSDictionary *)opponentCasterField {
    return @{ FXFormFieldHeader: @"Opponent Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: @"SGFactionOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }] };
}

- (NSString *)opponentCasterFieldDescription {
    return self.opponentCaster ? self.opponentCaster.model.name : nil;
}

- (NSDictionary *)opponentField {
    return @{ FXFormFieldViewController: @"SGGenericAddOptionsTableViewController",
              FXFormFieldOptions: @[ ] };
}

- (NSString *)opponentFieldDescription {
    return self.opponent ? self.opponent.name : nil;
}

- (NSDictionary *)dateField {
    return @{ FXFormFieldHeader: @"Required",
              FXFormFieldDefaultValue: [NSDate date]};
}

- (NSDictionary *)pointSizeField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)resultField {
    NSString *(^resultValueTransformer)(id) = ^(id value) {
        return value ? ((Result *)value).name : nil;
    };
    
    return @{ FXFormFieldViewController: @"SGGenericOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Result" sortKeys:@{ @"displayOrder": [NSNumber numberWithBool:YES] }],
              FXFormFieldValueTransformer: resultValueTransformer };
}

- (NSString *)resultFieldDescription {
    return self.result ? self.result.name : nil;
}

- (NSDictionary *)killPointsField {
    return @{ FXFormFieldHeader: @"Optional",
              FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)scenarioField {
    NSString *(^scenarioValueTransformer)(id) = ^(id value) {
        return value ? ((Scenario *)value).name : nil;
    };
    
    return @{ FXFormFieldViewController: @"SGGenericAddOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Scenario" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }],
              FXFormFieldValueTransformer: scenarioValueTransformer};
}

- (NSDictionary *)controlPointsField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)eventField {
    return @{ FXFormFieldViewController: @"SGGenericAddOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Event" sortKeys:@{ @"date": [NSNumber numberWithBool:NO] }] };
}

- (NSString *)eventFieldDescription {
    return self.event ? self.event.name : nil;
}

#pragma mark - Class Methods

- (NSArray *)sortedObjectArray:(NSString *)entityName sortKeys:(NSDictionary *)sortKeys {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (id sortKey in sortKeys) {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:[[sortKeys objectForKey:sortKey] boolValue]]];
    }
    return [[SGGenericRepository findAllEntitiesOfType:entityName context:appDelegate.managedObjectContext] sortedArrayUsingDescriptors:sortDescriptors];
}

@end