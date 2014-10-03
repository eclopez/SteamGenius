//
//  SGBattleInfoCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGBattleInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *opponentFactionImage;
@property (weak, nonatomic) IBOutlet UILabel *opponentCasterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerFactionImage;

@end
