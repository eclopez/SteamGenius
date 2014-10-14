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

@implementation SGFiltersForm

- (id)init {
    if (self = [super init]) {
        _attributes = @[ @"playerCaster.faction",
                         @"playerCaster.model",
                         @"opponentCaster.faction",
                         @"opponentCaster.model",
                         @"opponent",
                         @"date",
                         @"armyPoints",
                         @"result",
                         @"killPoints",
                         @"scenario",
                         @"controlPoints",
                         @"event" ];
        _attributeNames = @[ @"My faction",
                             @"My caster",
                             @"My opponent's faction",
                             @"My opponent's caster",
                             @"My opponent",
                             @"Date",
                             @"Points",
                             @"Result",
                             @"Kill points",
                             @"Scenario",
                             @"Control points",
                             @"Event"];
    }
    return self;
}

- (NSDictionary *)attributeField {
    NSString *(^attributeValueTransformer)(id) = ^(id value) {
        return value ? [_attributeNames objectAtIndex:[_attributes indexOfObject:value]] : nil;
    };
    
    return @{ FXFormFieldTitle: @"Attribute",
              FXFormFieldOptions: _attributes,
              FXFormFieldValueTransformer: attributeValueTransformer,
              FXFormFieldAction: @"attributeChangedAction" };
}

- (NSDictionary *)logicalOperatorField {
    if ([_attribute isEqualToString:@"playerCaster.faction"] ||
        [_attribute isEqualToString:@"playerCaster.model"] ||
        [_attribute isEqualToString:@"opponentCaster.faction"] ||
        [_attribute isEqualToString:@"opponentCaster.model"] ||
        [_attribute isEqualToString:@"result"]) {
        NSArray *operators = @[ @"==", @"!=" ];
        NSArray *operatorNames = @[ @"is", @"is not" ];
        NSString *(^operatorValueTransformer)(id) = ^(id value) {
            return value ? [operatorNames objectAtIndex:[operators indexOfObject:value]] : nil;
        };
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: operators,
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operatorChangedAction" };
    }
    
    if ([_attribute isEqualToString:@"date"]) {
        NSArray *options = @[@"<", @">"];
        return @{ FXFormFieldOptions: options };
    }
    
    return @{ FXFormFieldType: @"label" };
}

- (NSDictionary *)valueField {
    if ([_attribute isEqualToString:@"playerCaster.faction"] || [_attribute isEqualToString:@"opponentCaster.faction"]) {
        return @{ FXFormFieldViewController: @"SGFactionFilterOptionsTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }]};
    }
    
    return @{ FXFormFieldType: @"label" };
}

- (NSString *)valueFieldDescription {
    if ([self.value isKindOfClass:[Faction class]]) {
        return self.value ? ((Faction *)self.value).name: nil;
    }
    return @"";
}

- (NSArray *)excludedFields
{
    return @[ @"attributes", @"attributeNames" ];
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