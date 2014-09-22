//
//  SGCasterOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "Faction.h"
#import "SGFactionOptionsTableViewController.h"

@interface SGCasterOptionsTableViewController : UITableViewController <FXFormFieldViewController>

@property (strong, nonatomic) FXFormField *field;
@property (strong, nonatomic) Faction *faction;
@property (strong, nonatomic) SGFactionOptionsTableViewController *parent;

@end
