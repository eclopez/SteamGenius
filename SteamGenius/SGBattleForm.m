//
//  SGBattleForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleForm.h"
#import "AppDelegate.h"
#import "SGFactionsOptionTableViewController.h"
#import "SGCasterOptionsTableViewController.h"
#import "SGGenericAddOptionsTableViewController.h"
#import "SGGenericOptionsTableViewController.h"
#import "SGRepository.h"
#import "SteamGeniusKit.h"

@implementation SGBattleForm

- (id)init {
    if (self = [super init]) {
        _date = [NSDate date];
    }
    return self;
}

- (id)init:(Battle *)battle {
    if (self = [super init]) {
        _battle = battle ? battle : nil;
        _playerCaster = battle ? battle.playerCaster : nil;
        _opponentCaster = battle ? battle.opponentCaster : nil;
        _opponent = battle ? battle.opponent : nil;
        _date = battle ? battle.date : [NSDate date];
        _pointSize = battle ? battle.points : nil;
        _result = battle ? battle.result : nil;
        _mark3 = [battle.mark3 boolValue];
        _killPoints = battle ? battle.killPoints : nil;
        _scenario = battle ? battle.scenario : nil;
        _controlPoints = battle ? battle.controlPoints : nil;
        _opponentControlPoints = battle ? battle.opponentControlPoints : nil;
        _event = battle ? battle.event : nil;
        _notes = battle ? battle.notes : nil;
    }
    return self;
}

- (NSDictionary *)playerCasterField {
    return @{ FXFormFieldHeader: @"Player Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: [[SGFactionsOptionTableViewController alloc] init:^(UINavigationController *navController, FXFormField *field, Faction *faction){
                  SGCasterOptionsTableViewController *casterOptionsViewController = [[SGCasterOptionsTableViewController alloc] init];
                  casterOptionsViewController.field = field;
                  casterOptionsViewController.faction = faction;
                  [navController pushViewController:casterOptionsViewController animated:YES];
              }],
              FXFormFieldOptions: [self sortedObjectArray:@"Game" sortKeys:@{ @"name": [NSNumber numberWithBool:NO] }] };
}

- (NSString *)playerCasterFieldDescription {
    return self.playerCaster ? self.playerCaster.model.name : nil;
}

- (NSDictionary *)opponentCasterField {
    return @{ FXFormFieldHeader: @"Opponent Info",
              FXFormFieldTitle: @"Caster",
              FXFormFieldViewController: [[SGFactionsOptionTableViewController alloc] init:^(UINavigationController *navController, FXFormField *field, Faction *faction){
                  SGCasterOptionsTableViewController *casterOptionsViewController = [[SGCasterOptionsTableViewController alloc] init];
                  casterOptionsViewController.field = field;
                  casterOptionsViewController.faction = faction;
                  [navController pushViewController:casterOptionsViewController animated:YES];
              }],
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
    return @{ FXFormFieldHeader: @"Required" };
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

- (NSDictionary *)mark3Field {
  return @{ FXFormFieldHeader: @"Optional",
            FXFormFieldTitle: @"Mark 3" };
}

- (NSDictionary *)killPointsField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)scenarioField {
    //NSString *(^scenarioValueTransformer)(id) = ^(id value) {
    //    return value ? ((Scenario *)value).name : nil;
    //};
    
    return @{ FXFormFieldViewController: @"SGGenericAddOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Scenario" sortKeys:@{ @"name": [NSNumber numberWithBool:YES] }]
              };//FXFormFieldValueTransformer: scenarioValueTransformer};
}

- (NSString *)scenarioFieldDescription {
    return self.scenario ? self.scenario.name : nil;
}

- (NSDictionary *)controlPointsField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)opponentControlPointsField {
    return @{ FXFormFieldType: @"unsigned" };
}

- (NSDictionary *)eventField {
    return @{ FXFormFieldViewController: @"SGGenericAddOptionsTableViewController",
              FXFormFieldOptions: [self sortedObjectArray:@"Event" sortKeys:@{ @"date": [NSNumber numberWithBool:NO] }] };
}

- (NSString *)eventFieldDescription {
    return self.event ? self.event.name : nil;
}

- (NSDictionary *)notesField {
    return @{ FXFormFieldHeader: @"",
              FXFormFieldType: @"longtext" };
}

- (NSArray *)excludedFields {
    return @[ @"battle" ];
}

#pragma mark - Class Methods

- (NSArray *)sortedObjectArray:(NSString *)entityName sortKeys:(NSDictionary *)sortKeys {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (id sortKey in sortKeys) {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:[[sortKeys objectForKey:sortKey] boolValue]]];
    }
    return [[SGKRepository findAllEntitiesOfType:entityName predicate:nil context:appDelegate.managedObjectContext] sortedArrayUsingDescriptors:sortDescriptors];
}

@end