//
//  SGEmptyLabel.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/18/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGEmptyLabel.h"

@implementation SGEmptyLabel

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.attributedText = [[NSAttributedString alloc] initWithString:message
                                                                  attributes:@{NSForegroundColorAttributeName:textColor,
                                                                               NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:25.f],
                                                                               NSTextEffectAttributeName:NSTextEffectLetterpressStyle}];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
