//
//  SGBattleInfoCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleInfoCell.h"

@interface SGBattleInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *opponentLabel;

@end

@implementation SGBattleInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Date label
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:self.dateLabel.text
                                                                    attributes:@{NSShadowAttributeName:[self commonTextShadow]}];
    
    // Opponent label
    self.opponentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.opponentLabel.text
                                                                        attributes:@{NSShadowAttributeName:[self commonTextShadow]}];
    
    // Player caster name label
    self.playerCasterName.textAlignment = NSTextAlignmentRight;
    
    // Result name label
    self.resultNameLabel.adjustsFontSizeToFitWidth = NO;
    self.resultNameLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *resultStyle = [[NSMutableParagraphStyle alloc] init];
    CGFloat fontSize = self.resultNameLabel.font.pointSize;
    while (fontSize > 0.0)
    {
        resultStyle.maximumLineHeight = fontSize + 1;
        CGRect rectSize = [self.resultNameLabel.text
                           boundingRectWithSize:CGSizeMake(self.resultNameLabel.frame.size.width, CGFLOAT_MAX)
                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName: [UIFont fontWithName:self.resultNameLabel.font.fontName size:fontSize],
                                        NSParagraphStyleAttributeName: resultStyle}
                           context:nil];
        
        if (rectSize.size.height <= self.resultNameLabel.frame.size.height) break;
            fontSize -= 1.0;
    }
    self.resultNameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.resultNameLabel.text
                                                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:self.resultNameLabel.font.fontName size:fontSize],
                                                                                       NSParagraphStyleAttributeName: resultStyle}];
    self.resultNameLabel.textAlignment = NSTextAlignmentCenter;
    
    // Points label
    self.pointsLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private Methods

- (NSShadow *)commonTextShadow {
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [UIColor blackColor];
    textShadow.shadowBlurRadius = 2.f;
    textShadow.shadowOffset = CGSizeMake(0, 1.f);
    return textShadow;
}

@end