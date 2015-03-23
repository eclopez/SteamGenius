//
//  SGCoreDataObjects.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/22/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface SGCoreDataObjects : NSObject

+ (NSManagedObjectModel *)getManagedObjectModel;
+ (NSPersistentStoreCoordinator *)getPersistentStoreCoordinatorForManagedObjectModel:(NSManagedObjectModel *)model applicationDocumentsDirectoryURL:(NSURL *)applicationDocumentsDirectory;
+ (NSManagedObjectContext *)getManagedObjectContextForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
