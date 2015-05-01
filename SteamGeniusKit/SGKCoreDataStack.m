//
//  SGKCoreDataStack.m
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGKCoreDataStack.h"

#define kModelFileName @"SteamGenius"
#define kSQLStoreFileName @"SteamGenius.sqlite"
#define kAppGroupIdentifier @"group.com.eriklopez.SteamGenius"

#define kSharedIconsDirectoryName @"faction-icons"

@implementation SGKCoreDataStack

#pragma mark - Documents Directory

+ (NSURL *)sharedDocumentsDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
}

+ (NSURL *)sharedIconsDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *iconsDirectoryURL = [[self sharedDocumentsDirectory] URLByAppendingPathComponent:kSharedIconsDirectoryName];
    
    BOOL isDirectory;
    NSError *error;
    
    if (![manager fileExistsAtPath:iconsDirectoryURL.path isDirectory:&isDirectory]) {
        if (![manager createDirectoryAtPath:iconsDirectoryURL.path withIntermediateDirectories:YES attributes:nil error:&error]) {
            // HANDLE ERROR
            NSLog(@"Error creating icons directory in app group: %@", error.localizedDescription);
        }
    }
    
    return iconsDirectoryURL;
}

+ (BOOL)factionIconExists:(NSString *)factionName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[[self sharedIconsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", factionName]].path]) {
        return YES;
    }
    return NO;
}

#pragma mark - Core Data stack

+ (NSManagedObjectModel *)getManagedObjectModel {
    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:kModelFileName withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

+ (NSPersistentStoreCoordinator *)getPersistentStoreCoordinatorForManagedObjectModel:(NSManagedObjectModel *)model applicationDocumentsDirectoryURL:(NSURL *)applicationDocumentsDirectory {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURL *oldStoreURL = [applicationDocumentsDirectory URLByAppendingPathComponent:kSQLStoreFileName];
    NSURL *currentStoreURL = [[self sharedDocumentsDirectory] URLByAppendingPathComponent:kSQLStoreFileName];
    BOOL oldStoreExists = [manager fileExistsAtPath:oldStoreURL.path];
    BOOL currentStoreExists = [manager fileExistsAtPath:currentStoreURL.path];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption: @YES };
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (currentStoreExists || (!oldStoreExists && !currentStoreExists)) {
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:currentStoreURL options:options error:&error]) {
            NSDictionary *d = @{ NSLocalizedDescriptionKey : @"Failed to intialize the application's saved data.",
                                 NSLocalizedFailureReasonErrorKey : failureReason,
                                 NSUnderlyingErrorKey : error };
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:d];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
#warning Handle this error.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else {
        // MIGRATE!!
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:oldStoreURL options:options error:&error];
        NSPersistentStore *sourceStore = [coordinator persistentStoreForURL:oldStoreURL];
        if (sourceStore != nil) {
            NSPersistentStore *destinationStore = [coordinator migratePersistentStore:sourceStore toURL:currentStoreURL options:options withType:NSSQLiteStoreType error:&error];
            if (destinationStore != nil) {
                // Remove old data
                if ([manager fileExistsAtPath:oldStoreURL.path]) {
                    [manager removeItemAtPath:oldStoreURL.path error:&error];
                    if (error) {
                        NSLog(@"Error deleting sqlite database, %@: %@", error, [error localizedDescription]);
                    }
                }
            } else {
                // Handle error
                NSLog(@"Error migrating sqlite database %@: %@", error, [error localizedDescription]);
            }
        }
    }
    return coordinator;
}

+ (NSPersistentStoreCoordinator *)getReadOnlyPersistentStoreCoordinatorForManagedObjectModel:(NSManagedObjectModel *)model {
    NSURL *currentStoreURL = [[self sharedDocumentsDirectory] URLByAppendingPathComponent:kSQLStoreFileName];
    BOOL currentStoreExists = [[NSFileManager defaultManager] fileExistsAtPath:currentStoreURL.path];
    if (!currentStoreExists) { return nil; }
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption: @YES };
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:currentStoreURL options:options error:nil]) {
        return nil;
    }
    
    return coordinator;
}

+ (NSManagedObjectContext *)getManagedObjectContextForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator {
    if (!coordinator) { return nil; }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}


@end
