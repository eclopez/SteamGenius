//
//  SGFiltersListViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SGFiltersListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end