//
//  SGBattleDetailViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "FXForms.h"
#import "Battle.h"
#import "AppDelegate.h"

@interface SGBattleDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Battle *battle;

@end