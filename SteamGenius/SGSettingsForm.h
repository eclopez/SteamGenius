//
//  SGSettingsForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "SGProductsTableViewController.h"

@interface SGSettingsForm : NSObject <FXForm>

@property (nonatomic, copy) NSNumber *theme;
@property (strong, nonatomic) SGProductsTableViewController *products;
@property (nonatomic, strong) NSString *donate;

@end