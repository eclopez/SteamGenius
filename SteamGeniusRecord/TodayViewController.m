//
//  TodayViewController.m
//  SteamGeniusRecord
//
//  Created by Erik Lopez on 3/23/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUInteger wins = [[SGRepository findAllEntitiesOfType:@"Battle" predicate:nil context:self.managedObjectContext] count];
    _hello.text = [@(wins) stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
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
    _managedObjectModel = [SGCoreDataObjects getManagedObjectModel];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //_persistentStoreCoordinator = [SGCoreDataObjects getPersistentStoreCoordinatorForManagedObjectModel:[self managedObjectModel] applicationDocumentsDirectoryURL:[self applicationDocumentsDirectory]];
    _persistentStoreCoordinator = [SGCoreDataObjects getMigratedPersistentStoreCoordinatorForManagedObjectModel:[self managedObjectModel] applicationDocumentsDirectoryURL:[self applicationDocumentsDirectory]];
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [SGCoreDataObjects getManagedObjectContextForPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return _managedObjectContext;
}

@end
