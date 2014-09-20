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

@interface SGRepository : NSObject

//
// Create Methods
//
+ (DataVersion *)initWithEntityNamed:(NSString *)entityName version:(NSNumber *)version context:(NSManagedObjectContext *)context;
+ (Game *)initWithGameNamed:(NSString *)gameName shortName:(NSString *)shortName context:(NSManagedObjectContext *)context;
+ (Faction *)initWithFactioNamed:(NSString *)factionName shortName:(NSString *)shortName imageNamed:(NSString *)imageName releaseOrder:(NSNumber *)releaseOrder gameNamed:(NSString *)gameName context:(NSManagedObjectContext *)context;
+ (Model *)initWithModelNamed:(NSString *)modelName shortName:(NSString *)shortName incarnation:(NSNumber *)incarnation isEpic:(NSNumber *)isEpic isCavalry:(NSNumber *)isCavalry isBattleEngine:(NSNumber *)isBattleEngine context:(NSManagedObjectContext *)context;
+ (Caster *)initWithModelName:(NSString *)modelName factionName:(NSString *)factionName context:(NSManagedObjectContext *)context;
+ (Result *)initWithResultName:(NSString *)resultName winValue:(NSNumber *)winValue displayOrder:(NSNumber *)displayOrder context:(NSManagedObjectContext *)context;

@end
