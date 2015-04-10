//
//  Caster.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/25/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Battle, Faction, Model;

@interface Caster : NSManagedObject

@property (nonatomic, retain) Faction *faction;
@property (nonatomic, retain) Model *model;
@property (nonatomic, retain) NSSet *opponentBattles;
@property (nonatomic, retain) NSSet *playerBattles;
@end

@interface Caster (CoreDataGeneratedAccessors)

- (void)addOpponentBattlesObject:(Battle *)value;
- (void)removeOpponentBattlesObject:(Battle *)value;
- (void)addOpponentBattles:(NSSet *)values;
- (void)removeOpponentBattles:(NSSet *)values;

- (void)addPlayerBattlesObject:(Battle *)value;
- (void)removePlayerBattlesObject:(Battle *)value;
- (void)addPlayerBattles:(NSSet *)values;
- (void)removePlayerBattles:(NSSet *)values;

@end
