//
//  SGBattleCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/27/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Battle.h"

@interface SGBattleCell : UITableViewCell

@property (strong, nonatomic) Battle *battle;

@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UILabel *lblOpponent;
@property (strong, nonatomic) IBOutlet UIImageView *imgOpponentFaction;
@property (strong, nonatomic) IBOutlet UILabel *lblOpponentCaster;

@end