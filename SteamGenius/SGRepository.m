//
//  SGRepository.m
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGRepository.h"
#import "SteamGeniusKit.h"

@implementation SGRepository

#pragma mark - Create Methods

+ (DataVersion *)initWithEntityNamed:(NSString *)entityName version:(NSNumber *)version context:(NSManagedObjectContext *)context
{
    DataVersion *d = [NSEntityDescription insertNewObjectForEntityForName:@"DataVersion" inManagedObjectContext:context];
    [d setValue:entityName forKey:@"name"];
    [d setValue:version forKey:@"version"];
    return d;
}

+ (Game *)initWithGameNamed:(NSString *)gameName shortName:(NSString *)shortName context:(NSManagedObjectContext *)context
{
    Game *g = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
    [g setValue:gameName forKey:@"name"];
    [g setValue:shortName forKey:@"shortName"];
    return g;
}

+ (Faction *)initWithFactioNamed:(NSString *)factionName shortName:(NSString *)shortName color:(NSDictionary *)color imageNamed:(NSString *)imageName releaseOrder:(NSNumber *)releaseOrder gameNamed:(NSString *)gameName context:(NSManagedObjectContext *)context
{
    Game *fGame = [SGKRepository findOneEntityOfType:@"Game" entityKey:gameName keyField:@"name" context:context];
    Faction *f = [NSEntityDescription insertNewObjectForEntityForName:@"Faction" inManagedObjectContext:context];
    [f setValue:factionName forKey:@"name"];
    [f setValue:shortName forKey:@"shortName"];
    [f setValue:[UIColor colorWithRed:[[color valueForKey:@"red"] floatValue]/255.f
                                green:[[color valueForKey:@"green"] floatValue]/255.f
                                 blue:[[color valueForKey:@"blue"] floatValue]/255.f
                                alpha:[[color valueForKey:@"alpha"] floatValue]] forKey:@"color"];
    [f setValue:imageName forKey:@"imageName"];
    [f setValue:releaseOrder forKey:@"releaseOrder"];
    [f setValue:fGame forKey:@"game"];
    return f;
}

+ (Model *)initWithModelNamed:(NSString *)modelName shortName:(NSString *)shortName incarnation:(NSNumber *)incarnation isEpic:(NSNumber *)isEpic isCavalry:(NSNumber *)isCavalry isBattleEngine:(NSNumber *)isBattleEngine context:(NSManagedObjectContext *)context
{
    Model *m = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
    [m setValue:modelName forKey:@"name"];
    [m setValue:shortName forKey:@"shortName"];
    [m setValue:incarnation forKey:@"incarnation"];
    [m setValue:isEpic forKey:@"isEpic"];
    [m setValue:isCavalry forKey:@"isCavalry"];
    [m setValue:isBattleEngine forKey:@"isBattleEngine"];
    return m;
}

+ (Caster *)initWithModelNamed:(NSString *)modelName factionName:(NSString *)factionName context:(NSManagedObjectContext *)context
{
    Model *m = [SGKRepository findOneEntityOfType:@"Model" entityKey:modelName keyField:@"name" context:context];
    Faction *f = [SGKRepository findOneEntityOfType:@"Faction" entityKey:factionName keyField:@"name" context:context];
    Caster *c = [NSEntityDescription insertNewObjectForEntityForName:@"Caster" inManagedObjectContext:context];
    [c setValue:m forKey:@"model"];
    [c setValue:f forKey:@"faction"];
    return c;
}

+ (Result *)initWithResultNamed:(NSString *)resultName winValue:(NSNumber *)winValue displayOrder:(NSNumber *)displayOrder context:(NSManagedObjectContext *)context
{
    Result *r = [NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:context];
    [r setValue:resultName forKey:@"name"];
    [r setValue:winValue forKey:@"winValue"];
    [r setValue:displayOrder forKey:@"displayOrder"];
    return r;
}

+ (Opponent *)initWithOpponentNamed:(NSString *)opponentName context:(NSManagedObjectContext *)context
{
    Opponent *o = [NSEntityDescription insertNewObjectForEntityForName:@"Opponent" inManagedObjectContext:context];
    [o setValue:opponentName forKey:@"name"];
    return o;
}

+ (Scenario *)initWithScenarioNamed:(NSString *)scenarioName context:(NSManagedObjectContext *)context
{
    Scenario *s = [NSEntityDescription insertNewObjectForEntityForName:@"Scenario" inManagedObjectContext:context];
    [s setValue:scenarioName forKey:@"name"];
    return s;
}

+ (Event *)initWithEventNamed:(NSString *)eventName location:(NSString *)location date:(NSDate *)date isTournament:(BOOL)isTournament context:(NSManagedObjectContext *)context
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    [e setValue:eventName forKey:@"name"];
    [e setValue:location forKey:@"location"];
    [e setValue:date forKey:@"date"];
    [e setValue:[NSNumber numberWithBool:isTournament] forKey:@"isTournament"];
    return e;
}

+ (Battle *)initWithPlayerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result mark3:(BOOL)mark3 killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints opponentControlPoints:(NSNumber *)opponentControlPoints event:(Event *)event notes:(NSString *)notes context:(NSManagedObjectContext *)context
{
    Battle *b = [NSEntityDescription insertNewObjectForEntityForName:@"Battle" inManagedObjectContext:context];
    [b setValue:playerCaster forKey:@"playerCaster"];
    [b setValue:opponentCaster forKey:@"opponentCaster"];
    [b setValue:opponent forKey:@"opponent"];
    [b setValue:date forKey:@"date"];
    [b setValue:points forKey:@"points"];
    [b setValue:result forKey:@"result"];
    [b setValue:[NSNumber numberWithBool:mark3] forKey:@"mark3"];
    [b setValue:killPoints forKey:@"killPoints"];
    [b setValue:scenario forKey:@"scenario"];
    [b setValue:controlPoints forKey:@"controlPoints"];
    [b setValue:opponentControlPoints forKey:@"opponentControlPoints"];
    [b setValue:event forKey:@"event"];
    [b setValue:notes forKey:@"notes"];
    return b;
}

+ (BattleFilter *)initWithDisplayText:(NSString *)displayText predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context {
    BattleFilter *bf = [NSEntityDescription insertNewObjectForEntityForName:@"BattleFilter" inManagedObjectContext:context];
    [bf setValue:displayText forKey:@"displayText"];
    [bf setValue:predicate forKey:@"predicate"];
    // Activate the new filter by default
    [bf setValue:[NSNumber numberWithBool:YES] forKey:@"isActive"];
    return bf;
}

#pragma mark - Update Methods

+ (void)updateBattle:(Battle *)battle playerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result mark3:(BOOL)mark3 killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints opponentControlPoints:(NSNumber *)opponentControlPoints event:(Event *)event notes:(NSString *)notes
{
    battle.playerCaster = playerCaster;
    battle.opponentCaster = opponentCaster;
    battle.opponent = opponent;
    battle.date = date;
    battle.points = points;
    battle.result = result;
    battle.mark3 = [NSNumber numberWithBool:mark3];
    battle.killPoints = killPoints;
    battle.scenario = scenario;
    battle.controlPoints = controlPoints;
    battle.opponentControlPoints = opponentControlPoints;
    battle.event = event;
    battle.notes = notes;
}

+ (void)updateOpponent:(Opponent *)opponent name:(NSString *)name
{
    opponent.name = name;
}

+ (void)updateScenario:(Scenario *)scenario name:(NSString *)name
{
    scenario.name = name;
}

+ (void)updateEvent:(Event *)event name:(NSString *)name location:(NSString *)location date:(NSDate *)date isTournament:(BOOL)isTournament
{
    event.name = name;
    event.location = location;
    event.date = date;
    event.isTournament = [NSNumber numberWithBool:isTournament];
}

+ (void)updateBattleFilter:(BattleFilter *)battleFilter isActive:(BOOL)isActive
{
    battleFilter.isActive = [NSNumber numberWithBool:isActive];
}

@end