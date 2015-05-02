//
//  SGKCoreDataStack.h
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface SGKCoreDataStack : NSObject

+ (NSManagedObjectModel *)getManagedObjectModel;
+ (NSPersistentStoreCoordinator *)getPersistentStoreCoordinatorForManagedObjectModel:(NSManagedObjectModel *)model applicationDocumentsDirectoryURL:(NSURL *)applicationDocumentsDirectory;
+ (NSPersistentStoreCoordinator *)getReadOnlyPersistentStoreCoordinatorForManagedObjectModel:(NSManagedObjectModel *)model;
+ (NSManagedObjectContext *)getManagedObjectContextForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
