//
//  SGBattleCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/27/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleCell.h"
#import "Faction.h"
#import "Caster.h"
#import "Model.h"

@implementation SGBattleCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowBlurRadius:2.0f];
    [textShadow setShadowColor:[UIColor blackColor]];
    [textShadow setShadowOffset:CGSizeMake(0, 1.0f)];
    
    
    self.imgBackground.image = [UIImage imageNamed:@"BattleBarWin"];
    [self.contentView addSubview:self.imgBackground];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yy"];
    NSMutableAttributedString *dateAttributed = [[NSMutableAttributedString alloc] initWithString:[dateFormat stringFromDate:self.battle.date]];
    [dateAttributed addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0]
                           range:NSMakeRange(0, dateAttributed.length)];
    [dateAttributed addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:NSMakeRange(0, dateAttributed.length)];
    [dateAttributed addAttribute:NSShadowAttributeName
                           value:textShadow
                           range:NSMakeRange(0, dateAttributed.length)];
    self.lblDate.attributedText = dateAttributed;
    [self.contentView addSubview:self.lblDate];
    
    //
    // PLAYER
    //
    self.imgPlayerFaction.image = [UIImage imageNamed:self.battle.playerCaster.faction.imageName];
    [self.contentView addSubview:self.imgPlayerFaction];
    
    NSRange playerNameBreak = [self.battle.playerCaster.model.name rangeOfString:@", "];
    NSString *fullPlayerCasterName;
    if (playerNameBreak.location != NSNotFound) {
        NSString *name = [self.battle.playerCaster.model.name substringToIndex:playerNameBreak.location];
        NSString *title = [[self.battle.playerCaster.model.name substringFromIndex:playerNameBreak.location + 1] uppercaseString];
        fullPlayerCasterName = [NSString stringWithFormat:@"%@ %@", name, title];
    } else {
        fullPlayerCasterName = self.battle.playerCaster.model.name;
    }
    NSMutableParagraphStyle *playerStyle = [[NSMutableParagraphStyle alloc] init];
    [playerStyle setMaximumLineHeight:13.f];
    
    NSMutableAttributedString *playerCasterName = [[NSMutableAttributedString alloc] initWithString:fullPlayerCasterName];
    NSUInteger lastPlayerIndex = playerCasterName.length - 1;
    if (playerNameBreak.location != NSNotFound) {
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"AvenirNext-Medium" size:12.0]
                                 range:NSMakeRange(0, playerNameBreak.location)];
        [playerCasterName addAttribute:NSParagraphStyleAttributeName
                                 value:playerStyle
                                 range:NSMakeRange(0, playerNameBreak.location)];
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Futura" size:7.0]
                                 range:NSMakeRange(playerNameBreak.location + 1, lastPlayerIndex - playerNameBreak.location)];
        [playerCasterName replaceCharactersInRange:playerNameBreak withString:@"\n"];
    } else {
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"AvenirNext-Medium" size:12.0]
                                 range:NSMakeRange(0, playerCasterName.length)];
        [playerCasterName addAttribute:NSParagraphStyleAttributeName
                                 value:playerStyle
                                 range:NSMakeRange(0, playerCasterName.length)];
    }
    [playerCasterName addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:NSMakeRange(0, playerCasterName.length)];
    [playerCasterName addAttribute:NSShadowAttributeName
                             value:textShadow
                             range:NSMakeRange(0, playerCasterName.length)];
    
    self.lblPlayerCaster.attributedText = playerCasterName;
    self.lblPlayerCaster.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblPlayerCaster];
    
    //
    // OPPONENT
    //
    self.lblOpponentCaster.userInteractionEnabled = NO;
    
    self.lblOpponent.layer.shadowRadius = 0;
    self.lblOpponent.layer.shadowOpacity = 1.f;
    self.lblOpponent.layer.shadowOffset = CGSizeMake(0, 1.f);
    self.lblOpponent.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:self.lblOpponent];
    
    self.imgOpponentFaction.image = [UIImage imageNamed:self.battle.opponentCaster.faction.imageName];
    [self.contentView addSubview:self.imgOpponentFaction];
    
    self.lblOpponentCaster.userInteractionEnabled = NO;
    
    // Opponent caster name
    NSRange nameBreak = [self.battle.opponentCaster.model.name rangeOfString:@", "];
    NSString *fullOpponentCasterName;
    if (nameBreak.location != NSNotFound) {
        NSString *name = [self.battle.opponentCaster.model.name substringToIndex:nameBreak.location];
        NSString *title = [[self.battle.opponentCaster.model.name substringFromIndex:nameBreak.location + 1] uppercaseString];
        fullOpponentCasterName = [NSString stringWithFormat:@"%@ %@", name, title];
    } else {
        fullOpponentCasterName = self.battle.opponentCaster.model.name;
    }
    NSMutableParagraphStyle *opponentStyle = [[NSMutableParagraphStyle alloc] init];
    [opponentStyle setMaximumLineHeight:15.f];
    
    NSMutableAttributedString *opponentCasterName = [[NSMutableAttributedString alloc] initWithString:fullOpponentCasterName];
    NSUInteger lastOpponentIndex = opponentCasterName.length - 1;
    if (nameBreak.location != NSNotFound) {
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]
                                   range:NSMakeRange(0, nameBreak.location)];
        [opponentCasterName addAttribute:NSParagraphStyleAttributeName
                                   value:opponentStyle
                                   range:NSMakeRange(0, nameBreak.location)];
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Futura" size:8.0]
                                   range:NSMakeRange(nameBreak.location + 1, lastOpponentIndex - nameBreak.location)];
        [opponentCasterName replaceCharactersInRange:nameBreak withString:@"\n"];
    } else {
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]
                                   range:NSMakeRange(0, opponentCasterName.length)];
        [opponentCasterName addAttribute:NSParagraphStyleAttributeName
                                   value:opponentStyle
                                   range:NSMakeRange(0, opponentCasterName.length)];
    }
    [opponentCasterName addAttribute:NSForegroundColorAttributeName
                               value:[UIColor whiteColor]
                               range:NSMakeRange(0, opponentCasterName.length)];
    [opponentCasterName addAttribute:NSShadowAttributeName
                               value:textShadow
                               range:NSMakeRange(0, opponentCasterName.length)];
    self.lblOpponentCaster.attributedText = opponentCasterName;
    [self.contentView addSubview:self.lblOpponentCaster];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end