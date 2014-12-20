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
@property (nonatomic, strong) Opponent *opponent;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *pointSize;
@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) NSNumber *killPoints;
@property (nonatomic, strong) Scenario *scenario;
@property (nonatomic, strong) NSNumber *controlPoints;
@property (nonatomic, strong) Event *event;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) Battle *battle;

- (id)init:(Battle *)battle;
- (NSArray *)sortedObjectArray:(NSString *)entityName sortKeys:(NSDictionary *)sortKeys;

@end