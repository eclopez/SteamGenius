//
//  SGGenericAddOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "FXForms.h"
#import "SGLongPressTableViewCell.h"

@interface SGGenericAddOptionsTableViewController : UITableViewController <FXFormFieldViewController, NSFetchedResultsControllerDelegate, SGLongPressTableViewCellDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic, strong) FXFormField *field;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end