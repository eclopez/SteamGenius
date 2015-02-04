//
//  SGFactionsOptionTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 2/4/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "Faction.h"

@interface SGFactionsOptionTableViewController : UITableViewController <FXFormFieldViewController>

@property (strong, nonatomic) FXFormField *field;
@property (copy, nonatomic) void (^selectionHandler)(UINavigationController *navController, FXFormField *field, Faction *faction);

- (instancetype)init:(void (^)(UINavigationController *navController, FXFormField *field, Faction *faction))selectionHandler;

@end
