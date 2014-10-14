//
//  SGFactionFilterOptionsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface SGFactionFilterOptionsTableViewController : UITableViewController <FXFormFieldViewController>

@property (nonatomic, strong) FXFormField *field;

@end
