//
//  AppDelegate.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/10/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"
#import "SGSettingsManager.h"
#import "SGDataImport.h"
#import "BannerViewController.h"
#import "SGBattleDetailViewController.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "SGReceiptVerificator.h"

#define kCurrentGameVersion 1
#define kCurrentFactionVersion 1
#define kCurrentModelVersion 1
#define kCurrentCasterVersion 1
#define kCurrentResultVersion 1

#define kSteamGeniusPremiumProductIdentifier @"com.eriklopez.steamgenius.premium"
#define kRemoveAdsProductIdentifier @"com.eriklopez.steamgenius.removeads"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate {
    id<RMStoreReceiptVerificator> _receiptVerificator;
    RMStoreKeychainPersistence *_persistence;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadDefaultData];
    [SGSettingsManager initUserPreferences];
    [self configureStore];

    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    splitViewController.delegate = self;

    BannerViewController *bannerViewController = [[BannerViewController alloc] initWithContentViewController:splitViewController];
    self.window.rootViewController = bannerViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Fixes problem when date picker is showing and the app resigns active;
    // when you return, the date field is unresponsive.
    [self.window endEditing:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Fixes problem when date picker is showing and the app enters the background;
    // when you return, the date field is unresponsive.
    [self.window endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - RMStore Setup

- (void)configureStore
{
    _receiptVerificator = [[SGReceiptVerificator alloc] init];
    [RMStore defaultStore].receiptVerificator = _receiptVerificator;
    
    _persistence = [[RMStoreKeychainPersistence alloc] init];
    [RMStore defaultStore].transactionPersistor = _persistence;
}

#pragma mark - Load Default Data

- (void)loadDefaultData
{
    [SGDataImport importDataForEntityNamed:@"Game" version:kCurrentGameVersion entityType:SGEntityType_Game plistFileNamed:@"Game" context:self.managedObjectContext];
    [SGDataImport importDataForEntityNamed:@"Faction" version:kCurrentFactionVersion entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:self.managedObjectContext];
    [SGDataImport importDataForEntityNamed:@"Model" version:kCurrentModelVersion entityType:SGEntityType_Model plistFileNamed:@"Model" context:self.managedObjectContext];
    [SGDataImport importDataForEntityNamed:@"Caster" version:kCurrentCasterVersion entityType:SGEntityType_Caster plistFileNamed:@"Model" context:self.managedObjectContext];
    [SGDataImport importDataForEntityNamed:@"Result" version:kCurrentResultVersion entityType:SGEntityType_Result plistFileNamed:@"Result" context:self.managedObjectContext];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[SGBattleDetailViewController class]] && ([(SGBattleDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] battle] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.eriklopez.SteamGenius" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SteamGenius" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SteamGenius.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful during development.
        #warning Handle this error.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            #warning Handle this error.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
