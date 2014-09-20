//
//  Game.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faction;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSSet *factions;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addFactionsObject:(Faction *)value;
- (void)removeFactionsObject:(Faction *)value;
- (void)addFactions:(NSSet *)values;
- (void)removeFactions:(NSSet *)values;

@end
