//
//  SGBattleInfoCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import UIKit;

@interface SGBattleInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *opponentFactionColor;
@property (weak, nonatomic) IBOutlet UILabel *opponentCasterName;
@property (weak, nonatomic) IBOutlet UIView *playerFactionColor;
@property (weak, nonatomic) IBOutlet UILabel *playerCasterName;
@property (weak, nonatomic) IBOutlet UILabel *resultNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointsHeader;
@property (weak, nonatomic) IBOutlet UIView *pointsLine;
@property (weak, nonatomic) IBOutlet UILabel *resultHeader;
@property (weak, nonatomic) IBOutlet UIView *resultLine;

@end