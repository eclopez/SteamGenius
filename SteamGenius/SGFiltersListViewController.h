//
//  SGFiltersListViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/5/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@class GADBannerView;

@interface SGFiltersListViewController : UIViewController //<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;

@end