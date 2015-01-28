//
//  SGEmptyView.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/25/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGEmptyView.h"

@implementation SGEmptyView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (self) {
        _lblEmpty = [[UILabel alloc] initWithFrame:self.bounds];
        _lblEmpty.textAlignment = NSTextAlignmentCenter;
        _lblEmpty.attributedText = [[NSAttributedString alloc] initWithString:message
                                                                   attributes:@{NSForegroundColorAttributeName:textColor,
                                                                                NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:25.f],
                                                                                NSTextEffectAttributeName:NSTextEffectLetterpressStyle}];
        [self addSubview:_lblEmpty];
    }
    return self;
}

- (void)layoutSubviews {
    _lblEmpty.frame = self.bounds;
}

@end