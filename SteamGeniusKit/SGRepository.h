//
//  SGRepository.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/22/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreData;
#import "Battle.h"
#import "BattleFilter.h"
#import "Caster.h"
#import "DataVersion.h"
#import "Event.h"
#import "Faction.h"
#import "Game.h"
#import "Model.h"
#import "Opponent.h"
#import "Result.h"
#import "Scenario.h"

@interface SGRepository : NSObject

// Read Methods
+ (NSArray *)findAllEntitiesOfType:(NSString *)entityName predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;
+ (id)findOneEntityOfType:(NSString *)entityName entityKey:(id)entityKey keyField:(NSString *)keyField context:(NSManagedObjectContext *)context;

// Create Methods
+ (DataVersion *)initWithEntityNamed:(NSString *)entityName version:(NSNumber *)version context:(NSManagedObjectContext *)context;
+ (Game *)initWithGameNamed:(NSString *)gameName shortName:(NSString *)shortName context:(NSManagedObjectContext *)context;
+ (Faction *)initWithFactioNamed:(NSString *)factionName shortName:(NSString *)shortName color:(UIColor *)color imageNamed:(NSString *)imageName releaseOrder:(NSNumber *)releaseOrder gameNamed:(NSString *)gameName context:(NSManagedObjectContext *)context;
+ (Model *)initWithModelNamed:(NSString *)modelName shortName:(NSString *)shortName incarnation:(NSNumber *)incarnation isEpic:(NSNumber *)isEpic isCavalry:(NSNumber *)isCavalry isBattleEngine:(NSNumber *)isBattleEngine context:(NSManagedObjectContext *)context;
+ (Caster *)initWithModelNamed:(NSString *)modelName factionName:(NSString *)factionName context:(NSManagedObjectContext *)context;
+ (Result *)initWithResultNamed:(NSString *)resultName winValue:(NSNumber *)winValue displayOrder:(NSNumber *)displayOrder context:(NSManagedObjectContext *)context;
+ (Opponent *)initWithOpponentNamed:(NSString *)opponentName context:(NSManagedObjectContext *)context;
+ (Scenario *)initWithScenarioNamed:(NSString *)scenarioName context:(NSManagedObjectContext *)context;
+ (Event *)initWithEventNamed:(NSString *)eventName location:(NSString *)location date:(NSDate *)date isTournament:(BOOL)isTournament context:(NSManagedObjectContext *)context;
+ (Battle *)initWithPlayerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints opponentControlPoints:(NSNumber *)opponentControlPoints event:(Event *)event notes:(NSString *)notes context:(NSManagedObjectContext *)context;
+ (BattleFilter *)initWithDisplayText:(NSString *)displayText predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

// Update Methods
+ (void)updateBattle:(Battle *)battle playerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints opponentControlPoints:(NSNumber *)opponentControlPoints event:(Event *)event notes:(NSString *)notes;
+ (void)updateOpponent:(Opponent *)opponent name:(NSString *)name;
+ (void)updateScenario:(Scenario *)scenario name:(NSString *)name;
+ (void)updateEvent:(Event *)event name:(NSString *)name location:(NSString *)location date:(NSDate *)date isTournament:(BOOL)isTournament;
+ (void)updateBattleFilter:(BattleFilter *)battleFilter isActive:(BOOL)isActive;

@end
