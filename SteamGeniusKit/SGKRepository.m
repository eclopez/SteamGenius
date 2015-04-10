//
//  SGKRepository.m
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGKRepository.h"

@implementation SGKRepository

+ (NSArray *)findAllEntitiesOfType:(NSString *)entityName predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *entities = [context executeFetchRequest:fetchRequest error:nil];
    return entities != nil ? entities : nil;
}

+ (id)findOneEntityOfType:(NSString *)entityName entityKey:(id)entityKey keyField:(NSString *)keyField context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", keyField, entityKey];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *entities = [context executeFetchRequest:fetchRequest error:nil];
    return entities != nil ? [entities firstObject] : nil;
}

@end
