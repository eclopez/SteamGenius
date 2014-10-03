//
//  SGBattleListTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/30/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SGBattleListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end