//
//  SGDisplayTableViewCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/22/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGDisplayTableViewCell.h"

@implementation SGDisplayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    if (_nullValue) {
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14.f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end