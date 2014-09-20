//
//  Faction.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caster, Game;

@interface Faction : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * releaseOrder;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSSet *casters;
@property (nonatomic, retain) Game *game;
@end

@interface Faction (CoreDataGeneratedAccessors)

- (void)addCastersObject:(Caster *)value;
- (void)removeCastersObject:(Caster *)value;
- (void)addCasters:(NSSet *)values;
- (void)removeCasters:(NSSet *)values;

@end
