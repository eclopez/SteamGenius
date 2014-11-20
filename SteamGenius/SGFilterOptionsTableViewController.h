//
//  SGFilterOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SGFilterOptionsTableViewController : UITableViewController <FXFormFieldViewController>

@property (nonatomic, strong) FXFormField *field;

@end
