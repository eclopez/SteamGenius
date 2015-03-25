//
//  Model.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/22/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caster;

@interface Model : NSManagedObject

@property (nonatomic, retain) NSNumber * incarnation;
@property (nonatomic, retain) NSNumber * isBattleEngine;
@property (nonatomic, retain) NSNumber * isCavalry;
@property (nonatomic, retain) NSNumber * isEpic;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSSet *casters;
@end

@interface Model (CoreDataGeneratedAccessors)

- (void)addCastersObject:(Caster *)value;
- (void)removeCastersObject:(Caster *)value;
- (void)addCasters:(NSSet *)values;
- (void)removeCasters:(NSSet *)values;

@end
