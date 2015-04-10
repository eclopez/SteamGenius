//
//  Result.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/25/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Battle;

@interface Result : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * winValue;
@property (nonatomic, retain) NSSet *battles;
@end

@interface Result (CoreDataGeneratedAccessors)

- (void)addBattlesObject:(Battle *)value;
- (void)removeBattlesObject:(Battle *)value;
- (void)addBattles:(NSSet *)values;
- (void)removeBattles:(NSSet *)values;

@end
