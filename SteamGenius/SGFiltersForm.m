//
//  SGFiltersForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SGFiltersForm.h"
#import "AppDelegate.h"
#import "SGGenericRepository.h"
#import "SGFactionsOptionTableViewController.h"
#import "Faction.h"
#import "Model.h"
#import "Opponent.h"
#import "Scenario.h"
#import "Event.h"
#import "Result.h"

@implementation SGFiltersForm

- (id)init {
    if (self = [super init]) {
        _attributes = @{ @"playerCaster.faction.name": @"My faction",
                         @"playerCaster.model.name": @"My caster",
                         @"opponentCaster.faction.name": @"My opponent's faction",
                         @"opponentCaster.model.name": @"My opponent's caster",
                         @"opponent.name": @"My opponent",
                         @"date": @"Date",
                         @"points": @"Points",
                         @"result.name": @"Result",
                         @"killPoints": @"Kill points",
                         @"scenario.name": @"Scenario",
                         @"controlPoints": @"Control points",
                         @"event.name": @"Event" };
        
        _logicalOperators = @{ @"=": @"is",
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

#pragma mark - Attribute

- (NSDictionary *)attributeField {
    NSString *(^attributeValueTransformer)(id) = ^(id value) {
        return value ? [_attributes valueForKey:value]: nil;
    };
    
    NSArray *options = @[ @"playerCaster.faction.name", @"playerCaster.model.name", @"opponentCaster.faction.name", @"opponentCaster.model.name", @"opponent.name", @"date", @"points", @"result.name", @"killPoints", @"scenario.name", @"controlPoints", @"event.name" ];
    return @{ FXFormFieldOptions: options,
              FXFormFieldValueTransformer: attributeValueTransformer,
              FXFormFieldAction: @"attributeChangedAction",
              FXFormFieldViewController: @"SGFilterOptionsTableViewController" };
}

- (NSString *)attributeFieldDescription {
    return [_attributes valueForKey:self.attribute];
}

#pragma mark - Operation

- (NSDictionary *)operationField {
    NSString *(^operatorValueTransformer)(id) = ^(id value) {
        return value ? [_logicalOperators valueForKey:value] : nil;
    };
    
    if ([_attribute isEqualToString:@"playerCaster.faction.name"] ||
        [_attribute isEqualToString:@"playerCaster.model.name"] ||
        [_attribute isEqualToString:@"opponentCaster.faction.name"] ||
        [_attribute isEqualToString:@"opponentCaster.model.name"] ||
        [_attribute isEqualToString:@"result.name"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"=", @"!=" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController" };
    }
    else if ([_attribute isEqualToString:@"opponent.name"] ||
             [_attribute isEqualToString:@"scenario.name"] ||
             [_attribute isEqualToString:@"event.name"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"=", @"!=", @"=nil", @"!=nil" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController" };
    }
    else if ([_attribute isEqualToString:@"points"] ||
             [_attribute isEqualToString:@"date"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"=", @">", @">=", @"<", @"<=" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController" };
    }
    else if ([_attribute isEqualToString:@"killPoints"] ||
             [_attribute isEqualToString:@"controlPoints"]) {
        return @{ FXFormFieldTitle: @"Operator",
                  FXFormFieldOptions: @[ @"=", @">", @">=", @"<", @"<=", @"=nil", @"!=nil" ],
                  FXFormFieldValueTransformer: operatorValueTransformer,
                  FXFormFieldAction: @"operationChangedAction",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController" };
    }
    
    
    return @{ FXFormFieldType: @"label" };
}

- (NSString *)operationFieldDescription {
    return [_logicalOperators valueForKey:self.operation];
}

#pragma mark - Value

- (NSDictionary *)attributeValueField {
    NSString *(^nameValueTransformer)(id) = ^(id value) {
        return value ? [value objectForKey:@"name"] : nil;
    };
    
    if (([_attribute isEqualToString:@"playerCaster.faction.name"] || [_attribute isEqualToString:@"opponentCaster.faction.name"]) && self.operation != nil) {
        return @{ FXFormFieldTitle: @"Faction",
                  FXFormFieldViewController: @"SGFactionsOptionTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }],
                  FXFormFieldValueTransformer: nameValueTransformer };
    }
    
    if (([_attribute isEqualToString:@"playerCaster.model.name"] || [_attribute isEqualToString:@"opponentCaster.model.name"]) && self.operation != nil) {
        return @{ FXFormFieldTitle: @"Model",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Model" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }],
                  FXFormFieldValueTransformer: nameValueTransformer };
    }
    
    if ([_attribute isEqualToString:@"result.name"] && self.operation != nil) {
        return @{ FXFormFieldTitle: @"Result",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Result" sortKeys:@{ @"displayOrder": [NSNumber numberWithBool:YES] }],
                  FXFormFieldValueTransformer: nameValueTransformer };
    }
    
    if ([_attribute isEqualToString:@"opponent.name"] && self.operation != nil) {
        if ([self.operation isEqual:@"=nil"] || [self.operation isEqual:@"!=nil"]) {
            return @{ FXFormFieldTitle: @"",
                      FXFormFieldType: @"label" };
        } else {
        return @{ FXFormFieldTitle: @"Opponent",
                  FXFormFieldViewController: @"SGFilterOptionsTableViewController",
                  FXFormFieldOptions: [self sortedObjectArray:@"Opponent" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }],
                  FXFormFieldValueTransformer: nameValueTransformer };
        }
    }
    
    if ([_attribute isEqualToString:@"scenario.name"] && self.operation != nil) {
        if ([self.operation isEqual:@"=nil"] || [self.operation isEqual:@"!=nil"]) {
            return @{ FXFormFieldTitle: @"",
                      FXFormFieldType: @"label" };
        } else {
            return @{ FXFormFieldTitle: @"Scenario",
                      FXFormFieldViewController: @"SGFilterOptionsTableViewController",
                      FXFormFieldOptions: [self sortedObjectArray:@"Scenario" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }],
                      FXFormFieldValueTransformer: nameValueTransformer };
        }
    }
    
    if ([_attribute isEqualToString:@"event.name"] && self.operation != nil) {
        if ([self.operation isEqual:@"=nil"] || [self.operation isEqual:@"!=nil"]) {
            return @{ FXFormFieldTitle: @"",
                      FXFormFieldType: @"label" };
        } else {
            return @{ FXFormFieldTitle: @"Event",
                      FXFormFieldViewController: @"SGFilterOptionsTableViewController",
                      FXFormFieldOptions: [self sortedObjectArray:@"Event" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }],
                      FXFormFieldValueTransformer: nameValueTransformer };
        }
    }
    
    if ([_attribute isEqualToString:@"points"] && self.operation != nil) {
        return @{ FXFormFieldTitle: @"Value",
                  FXFormFieldType: @"unsigned" };
    }
    
    if (([_attribute isEqualToString:@"killPoints"] ||
         [_attribute isEqualToString:@"controlPoints"]) && self.operation != nil) {
        if ([self.operation isEqual:@"=nil"] || [self.operation isEqual:@"!=nil"]) {
            return @{ FXFormFieldTitle: @"",
                      FXFormFieldType: @"label" };
        } else {
            return @{ FXFormFieldTitle: @"Value",
                      FXFormFieldType: @"unsigned" };
        }
    }
    
    if ([_attribute isEqualToString:@"date"] && self.operation != nil) {
        return @{ FXFormFieldTitle: @"Date",
                  FXFormFieldType: @"date",
                  FXFormFieldDefaultValue: [NSDate date] };
    }
    
    return @{ FXFormFieldTitle: @"Value",
              FXFormFieldType: @"label" };
}

- (NSString *)attributeValueFieldDescription {
    if ([self.attributeValue isKindOfClass:[Faction class]]) {
        return self.attributeValue ? ((Faction *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[Model class]]) {
        return self.attributeValue ? ((Model *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:self.attributeValue];
    }
    else if ([self.attributeValue isKindOfClass:[Result class]]) {
        return self.attributeValue ? ((Result *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[Opponent class]]) {
        return self.attributeValue ? ((Opponent *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[Scenario class]]) {
        return self.attributeValue ? ((Scenario *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[Event class]]) {
        return self.attributeValue ? ((Event *)self.attributeValue).name : nil;
    }
    else if ([self.attributeValue isKindOfClass:[NSString class]]) {
        return self.attributeValue;
    }
    else if ([(NSString *)self.attributeValue intValue]) {
        return [self.attributeValue stringValue];
    }
    return @"";
}

#pragma mark - FXForms Methods

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