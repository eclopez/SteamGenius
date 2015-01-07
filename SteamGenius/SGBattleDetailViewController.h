//
//  SGBattleDetailViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "FXForms.h"
#import "Battle.h"

@interface SGBattleDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Battle *battle;

@end