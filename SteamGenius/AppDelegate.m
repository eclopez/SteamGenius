//
//  AppDelegate.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/10/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "AppDelegate.h"
#import "SGSettingsManager.h"
#import "SGDataImport.h"
#import "BannerViewController.h"
#import "SGBattleDetailViewController.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "SGReceiptVerificator.h"

// When adding new models, both model version and caster version need to be incremented.
#define kCurrentGameVersion 1
#define kCurrentFactionVersion 1
#define kCurrentModelVersion 4
#define kCurrentCasterVersion 4
#define kCurrentResultVersion 1

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

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:@"com.eriklopez.steamgenius.createbattle"]) {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CreateBattle"];
        [navigationController presentViewController:controller animated:YES completion:nil];
    }
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
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [SGKCoreDataStack getManagedObjectModel];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [SGKCoreDataStack getPersistentStoreCoordinatorForManagedObjectModel:[self managedObjectModel] applicationDocumentsDirectoryURL:[self applicationDocumentsDirectory]];
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [SGKCoreDataStack getManagedObjectContextForPersistentStoreCoordinator:[self persistentStoreCoordinator]];
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
