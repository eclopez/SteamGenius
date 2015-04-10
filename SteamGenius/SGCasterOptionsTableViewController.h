//
//  SGCasterOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import UIKit;
#import "Faction.h"
#import "FXForms.h"

@interface SGCasterOptionsTableViewController : UITableViewController <FXFormFieldViewController, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) FXFormField *field;
@property (strong, nonatomic) Faction *faction;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end