//
//  SGRepository.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataVersion.h"
#import "Game.h"
#import "Faction.h"
#import "Model.h"
#import "Caster.h"
#import "Result.h"
#import "Opponent.h"
#import "Scenario.h"
#import "Event.h"
#import "Battle.h"
#import "BattleFilter.h"

@interface SGRepository : NSObject

//
// Create Methods
//
+ (DataVersion *)initWithEntityNamed:(NSString *)entityName version:(NSNumber *)version context:(NSManagedObjectContext *)context;
+ (Game *)initWithGameNamed:(NSString *)gameName shortName:(NSString *)shortName context:(NSManagedObjectContext *)context;
+ (Faction *)initWithFactioNamed:(NSString *)factionName shortName:(NSString *)shortName imageNamed:(NSString *)imageName releaseOrder:(NSNumber *)releaseOrder gameNamed:(NSString *)gameName context:(NSManagedObjectContext *)context;
+ (Model *)initWithModelNamed:(NSString *)modelName shortName:(NSString *)shortName incarnation:(NSNumber *)incarnation isEpic:(NSNumber *)isEpic isCavalry:(NSNumber *)isCavalry isBattleEngine:(NSNumber *)isBattleEngine context:(NSManagedObjectContext *)context;
+ (Caster *)initWithModelNamed:(NSString *)modelName factionName:(NSString *)factionName context:(NSManagedObjectContext *)context;
+ (Result *)initWithResultNamed:(NSString *)resultName winValue:(NSNumber *)winValue displayOrder:(NSNumber *)displayOrder context:(NSManagedObjectContext *)context;
+ (Opponent *)initWithOpponentNamed:(NSString *)opponentName context:(NSManagedObjectContext *)context;
+ (Scenario *)initWithScenarioNamed:(NSString *)scenarioName context:(NSManagedObjectContext *)context;
+ (Event *)initWithEventNamed:(NSString *)eventName location:(NSString *)location date:(NSDate *)date isTournament:(BOOL)isTournament context:(NSManagedObjectContext *)context;
+ (Battle *)initWithPlayerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints event:(Event *)event context:(NSManagedObjectContext *)context;
+ (BattleFilter *)initWithDisplayText:(NSString *)displayText predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

@end