//
//  SGGenericRepository.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGGenericRepository.h"

@implementation SGGenericRepository

+ (NSArray *)findAllEntitiesOfType:(NSString *)entityName context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSArray *entities = [context executeFetchRequest:fetchRequest error:nil];
    return entities != nil ? entities : nil;
}

+ (id)findOneEntityOfType:(NSString *)entityName entityKey:(NSString *)entityKey keyField:(NSString *)keyField context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Escape quotation marks for predicate
    entityKey = [entityKey stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = \"%@\"", keyField, entityKey]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *entities = [context executeFetchRequest:fetchRequest error:nil];
    return entities != nil ? [entities firstObject] : nil;
}

@end