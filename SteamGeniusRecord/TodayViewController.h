//
//  TodayViewController.h
//  SteamGeniusRecord
//
//  Created by Erik Lopez on 3/23/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import UIKit;
@import SteamGeniusKit;

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *wins;
@property (weak, nonatomic) IBOutlet UILabel *losses;
@property (weak, nonatomic) IBOutlet UILabel *draws;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end