//
//  AppDelegate.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/10/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import UIKit;
@import CoreData;
@import StoreKit;
@import SteamGeniusKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)loadDefaultData;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end