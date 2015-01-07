//
//  SGFiltersListViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface SGFiltersListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isBannerVisible;
@property (strong, nonatomic) ADBannerView *adView;

@end
