//
//  Opponent.h
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Battle;

@interface Opponent : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *battles;
@end

@interface Opponent (CoreDataGeneratedAccessors)

- (void)addBattlesObject:(Battle *)value;
- (void)removeBattlesObject:(Battle *)value;
- (void)addBattles:(NSSet *)values;
- (void)removeBattles:(NSSet *)values;

@end
