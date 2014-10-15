//
//  SGFiltersForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SGFiltersForm.h"
#import "SGGenericRepository.h"
#import "SGFactionFilterOptionsTableViewController.h"
#import "Faction.h"
#import "Model.h"

@implementation SGFiltersForm

- (id)init {
    if (self = [super init]) {
        _attributes = @{ @"playerCaster.faction": @"My faction",
                         @"playerCaster.model": @"My caster",
                         @"opponentCaster.faction": @"My opponent's faction",
                         @"opponentCaster.model": @"My opponent's caster",
                         @"opponent": @"My opponent",
                         @"date": @"Date",
                         @"armyPoints": @"Points",
                         @"result": @"Result",
                         @"killPoints": @"Kill points",
                         @"scenario": @"Scenario",
                         @"controlPoints": @"Control points",
                         @"event": @"Event" };
        
        _logicalOperators = @{ @"==": @"is",
                               @"!=": @"is not",
                               @"!=nil": @"is set",
                               @"=nil": @"is not set",
                               @">": @"greater than",
                               @"<": @"less than",
                               @">=": @"greater than or equal to",
                               @"<=": @"less than or equal to" };
    }
    return self;
}

- (NSDictionary *)attributeField {
    NSString *(^attributeValueTransformer)(id) = ^(id value) {
        return value ? [_attributes valueForKey:value]: nil;
    };
    
    NSArray *options = @[ @"playerCaster.faction", @"playerCaster.model", @"opponentCaster.faction", @"opponentCaster.model", @"opponent", @"date",
                          @"armyPoints", @"result", @"killPoints", @"scenario", @"controlPoints", @"event" ];
    return @{ FXFormFieldOptions: options,
              FXFormFieldValueTransformer: attributeValueTransformer,
              FXFormFieldAction: @"attributeChangedAction" };
}

- (NSDictionary *)operationField {
    NSString *(^operatorValueTransformer)(id) = ^(id value) {
        return value ? [_logicalOperators valueForKey:value] : nil;
    };
    
    if ([_attribute isEqualToString:@"playerCaster.faction"] ||
        [_attribute isEqualToString:@"playerCaster.model"] ||
        [_attribute isEqualToString:@"opponentCaster.faction"] ||
        [_attribute isEqualToString:@"opponentCaster.model"] ||
        [_attribute isEqualToString:@"result"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"==", @"!=" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction" };
    }
    
    if ([_attribute isEqualToString:@"opponent"] ||
        [_attribute isEqualToString:@"scenario"] ||
        [_attribute isEqualToString:@"event"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"==", @"!=", @"=nil", @"!=nil" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction" };
    }
    
    if ([_attribute isEqualToString:@"armyPoints"] ||
        [_attribute isEqualToString:@"killPoints"] ||
        [_attribute isEqualToString:@"controlPoints"] ||
        [_attribute isEqualToString:@"date"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"==", @">", @">=", @"<", @"<=" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction" };
    }
    
    return @{ FXFormFieldType: @"label" };
}

- (NSDictionary *)valueField {
    if (([_attribute isEqualToString:@"playerCaster.faction"] || [_attribute isEqualToString:@"opponentCaster.faction"]) && self.operation != nil) {
        return @{ FXFormFieldViewController: @"SGFactionFilterOptionsTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }]};
    }
    
    if (([_attribute isEqualToString:@"armyPoints"] ||
        [_attribute isEqualToString:@"killPoints"] ||
        [_attribute isEqualToString:@"controlPoints"]) && self.operation != nil) {
        return @{ FXFormFieldType: @"unsigned" };
    }
    
    if ([_attribute isEqualToString:@"date"] && self.operation != nil) {
        return @{ FXFormFieldType: @"date",
                  FXFormFieldDefaultValue: [NSDate date] };
    }
    
    return @{ FXFormFieldType: @"label" };
}

- (NSString *)valueFieldDescription {
    if ([self.value isKindOfClass:[Faction class]]) {
        return self.value ? ((Faction *)self.value).name : nil;
    }
    if ([self.value isKindOfClass:[Model class]]) {
        return self.value ? ((Model *)self.value).name : nil;
    }
    return [self.value stringValue];
}

- (NSArray *)excludedFields
{
    return @[ @"attributes", @"logicalOperators" ];
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