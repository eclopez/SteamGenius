//
//  SGFactionOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SGFactionOptionsTableViewController : UITableViewController <FXFormFieldViewController>

@property (nonatomic, strong) FXFormField *field;

@end