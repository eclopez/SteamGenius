//
//  SGGenericRepository.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SGGenericRepository : NSObject

//
// Read Methods
//
+ (NSArray *)findAllEntitiesOfType:(NSString *)entityName context:(NSManagedObjectContext *)context;
+ (id)findOneEntityOfType:(NSString *)entityName entityKey:(NSString *)entityKey keyField:(NSString *)keyField context:(NSManagedObjectContext *)context;

@end