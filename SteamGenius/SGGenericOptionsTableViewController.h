//
//  SGGenericOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SGGenericOptionsTableViewController : UITableViewController <FXFormFieldViewController>

@property (nonatomic, strong) FXFormField *field;

@end
