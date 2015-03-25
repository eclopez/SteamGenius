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
    self.preferredContentSize = CGSizeMake(0.f, 100.f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self updateWidget];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

#pragma mark - Data Methods

- (void)updateWidget {
    [self managedObjectModel];
    [self persistentStoreCoordinator];
    if (_persistentStoreCoordinator) {
        NSPredicate *wins = [NSPredicate predicateWithFormat:@"result.winValue > %@", @0];
        NSPredicate *draws = [NSPredicate predicateWithFormat:@"result.winValue == %@", @0];
        NSPredicate *losses = [NSPredicate predicateWithFormat:@"result.winValue < %@", @0];
        
        NSArray *battles = [SGRepository findAllEntitiesOfType:@"Battle" predicate:nil context:self.managedObjectContext];
        
        NSUInteger numberOfWins = [[battles filteredArrayUsingPredicate:wins] count];
        NSUInteger numberOfDraws = [[battles filteredArrayUsingPredicate:draws] count];
        NSUInteger numberOfLosses = [[battles filteredArrayUsingPredicate:losses] count];
        
        self.wins.text = [@(numberOfWins) stringValue];
        self.draws.text = [@(numberOfDraws) stringValue];
        self.losses.text = [@(numberOfLosses) stringValue];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    _persistentStoreCoordinator = [SGCoreDataObjects getReadOnlyPersistentStoreCoordinatorForManagedObjectModel:[self managedObjectModel]];
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
