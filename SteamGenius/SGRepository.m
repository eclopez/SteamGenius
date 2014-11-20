//
//  SGRepository.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGRepository.h"
#import "SGGenericRepository.h"

@implementation SGRepository

#pragma mark -
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

+ (Faction *)initWithFactioNamed:(NSString *)factionName shortName:(NSString *)shortName imageNamed:(NSString *)imageName releaseOrder:(NSNumber *)releaseOrder gameNamed:(NSString *)gameName context:(NSManagedObjectContext *)context
{
    Game *fGame = [SGGenericRepository findOneEntityOfType:@"Game" entityKey:gameName keyField:@"name" context:context];
    Faction *f = [NSEntityDescription insertNewObjectForEntityForName:@"Faction" inManagedObjectContext:context];
    [f setValue:factionName forKey:@"name"];
    [f setValue:shortName forKey:@"shortName"];
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
    Model *m = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:modelName keyField:@"name" context:context];
    Faction *f = [SGGenericRepository findOneEntityOfType:@"Faction" entityKey:factionName keyField:@"name" context:context];
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

+ (Battle *)initWithPlayerCaster:(Caster *)playerCaster opponentCaster:(Caster *)opponentCaster opponent:(Opponent *)opponent date:(NSDate *)date points:(NSNumber *)points result:(Result *)result killPoints:(NSNumber *)killPoints scenario:(Scenario *)scenario controlPoints:(NSNumber *)controlPoints event:(Event *)event context:(NSManagedObjectContext *)context
{
    Battle *b = [NSEntityDescription insertNewObjectForEntityForName:@"Battle" inManagedObjectContext:context];
    [b setValue:playerCaster forKey:@"playerCaster"];
    [b setValue:opponentCaster forKey:@"opponentCaster"];
    [b setValue:opponent forKey:@"opponent"];
    [b setValue:date forKey:@"date"];
    [b setValue:points forKey:@"points"];
    [b setValue:result forKey:@"result"];
    [b setValue:killPoints forKey:@"killPoints"];
    [b setValue:scenario forKey:@"scenario"];
    [b setValue:controlPoints forKey:@"controlPoints"];
    [b setValue:event forKey:@"event"];
    return b;
}

+ (BattleFilter *)initWithDisplayText:(NSString *)displayText predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context {
    BattleFilter *bf = [NSEntityDescription insertNewObjectForEntityForName:@"BattleFilter" inManagedObjectContext:context];
    [bf setValue:displayText forKey:@"displayText"];
    [bf setValue:predicate forKey:@"predicate"];
    return bf;
}

@end