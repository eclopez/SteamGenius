//
//  SGStatsViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 7/5/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@import SteamGeniusKit;
#import "BattleFilter.h"
#import "Battle.h"
#import "Caster.h"
#import "Model.h"

@interface SGStatsViewController : UIViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *battles;
@property (weak, nonatomic) NSMutableOrderedSet *playerCasters;
@property (weak, nonatomic) NSMutableOrderedSet *opponentCasters;

@end
