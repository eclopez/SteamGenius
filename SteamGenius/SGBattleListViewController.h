//
//  SGBattleListViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface SGBattleListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIImageView *recordViewBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *winTotal;
@property (weak, nonatomic) IBOutlet UILabel *drawTotal;
@property (weak, nonatomic) IBOutlet UILabel *lossTotal;

@end