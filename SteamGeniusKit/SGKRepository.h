//
//  SGKRepository.h
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface SGKRepository : NSObject

+ (NSArray *)findAllEntitiesOfType:(NSString *)entityName predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;
+ (id)findOneEntityOfType:(NSString *)entityName entityKey:(id)entityKey keyField:(NSString *)keyField context:(NSManagedObjectContext *)context;

@end