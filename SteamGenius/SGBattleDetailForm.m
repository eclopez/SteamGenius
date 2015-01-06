//
//  SGBattleDetailForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleDetailForm.h"
#import "Model.h"
#import "Opponent.h"
#import "Result.h"
#import "SGDisplayTableViewCell.h"

@implementation SGBattleDetailForm

- (id)init:(Battle *)battle {
    if (self = [super init]) {
        _battle = battle ? battle : nil;
    }
    return self;
}

- (NSDictionary *)playerCasterField {
    return @{ FXFormFieldHeader: @"My Info",
              FXFormFieldTitle: self.battle.playerCaster != nil ? self.battle.playerCaster.model.name : @"None",
              FXFormFieldType: @"label" };
}

- (NSDictionary *)opponentCasterField {
    return @{ FXFormFieldHeader: @"Opponent Info",
              FXFormFieldTitle: self.battle.opponentCaster != nil ? self.battle.opponentCaster.model.name : @"None",
              FXFormFieldType: @"label" };
}

- (NSDictionary *)opponentField {
    return @{ FXFormFieldTitle: self.battle.opponent != nil ? self.battle.opponent.name : @"None",
              FXFormFieldType: @"label" };
}

- (NSDictionary *)dateField {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM d, yyyy";
    return @{ FXFormFieldHeader: @"Required Info",
              FXFormFieldTitle: self.battle.date != nil ? [formatter stringFromDate:self.battle.date] : @"None",
              FXFormFieldType: @"label" };
}

- (NSDictionary *)pointsField {
    return @{ FXFormFieldTitle: self.battle.points != nil ? [self.battle.points stringValue] : @"None",
              FXFormFieldType: @"label" };
}

/*- (NSDictionary *)resultField {
    return @{ FXFormFieldTitle: self.battle.result != nil ? self.battle.result.name : @"None",
              FXFormFieldType: @"label" };
}*/

- (NSArray *)excludedFields {
    return @[ @"battle" ];
}

@end