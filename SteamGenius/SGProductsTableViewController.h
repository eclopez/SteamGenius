//
//  SGProductsTableViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 1/27/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

@interface SGProductsTableViewController : UITableViewController <SKProductsRequestDelegate>

@property (strong, nonatomic) NSArray *products;

@end
