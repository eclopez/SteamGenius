//
//  SGBattleForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Faction.h"
#import "Opponent.h"
#import "Result.h"
#import "Scenario.h"
#import "Event.h"

@interface SGBattleForm : NSObject <FXForm>

@property (nonatomic, strong) Caster *playerCaster;
@property (nonatomic, strong) Caster *opponentCaster;
@property (nonatomic, copy) Opponent *opponent;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *pointSize;
@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) NSNumber *killPoints;
@property (nonatomic, copy) Scenario *scenario;
@property (nonatomic, copy) NSNumber *controlPoints;
@property (nonatomic, copy) Event *event;

- (NSArray *)sortedObjectArray:(NSString *)entityName sortKeys:(NSDictionary *)sortKeys;

@end