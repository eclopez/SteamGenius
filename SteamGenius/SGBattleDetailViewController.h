//
//  SGBattleDetailViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/6/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Battle.h"

@interface SGBattleDetailViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) Battle *battle;

@end
