//
//  Event.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/22/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Battle;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isTournament;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *battles;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addBattlesObject:(Battle *)value;
- (void)removeBattlesObject:(Battle *)value;
- (void)addBattles:(NSSet *)values;
- (void)removeBattles:(NSSet *)values;

@end
