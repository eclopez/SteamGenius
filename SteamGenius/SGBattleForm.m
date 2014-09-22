//
//  SGBattleForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleForm.h"
#import "SGCasterFormCell.h"
#import "AppDelegate.h"
#import "SGGenericRepository.h"

@implementation SGBattleForm

- (NSDictionary *)playerCasterField {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *games = [SGGenericRepository findAllEntitiesOfType:@"Game" context:appDelegate.managedObjectContext];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    games = [games sortedArrayUsingDescriptors:sortDescriptors];
    
    void (^playerCasterChanged)(id) = ^(SGCasterFormCell *sender) {
        NSLog(@"%@", sender.field.value);
    };
    
    NSString *(^casterValueTransformer)(id) = ^(id value) {
        return value ? ((Caster *)value).model.name : nil;
    };
    
    return @{ FXFormFieldKey: @"playerCaster",
              FXFormFieldHeader: @"Player Info",
              FXFormFieldCell: @"SGCasterFormCell",
              FXFormFieldOptions: games,
              FXFormFieldAction: playerCasterChanged,
              FXFormFieldValueTransformer: casterValueTransformer };
}

- (NSDictionary *)opponentCasterField {
    return @{ FXFormFieldHeader: @"Opponent Info" };
}

@end