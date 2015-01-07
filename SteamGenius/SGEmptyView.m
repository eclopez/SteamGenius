//
//  SGEmptyView.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/6/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGEmptyView.h"

@implementation SGEmptyView

- (instancetype)initWithFrame:(CGRect)frame emptyMessage:(NSString *)emptyMessage color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lblEmpty = [[UILabel alloc] initWithFrame:frame];
        lblEmpty.attributedText = [[NSAttributedString alloc] initWithString:emptyMessage
                                                                  attributes:@{NSForegroundColorAttributeName:color,
                                                                               NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:25.f],
                                                                               NSTextEffectAttributeName:NSTextEffectLetterpressStyle}];;
        lblEmpty.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblEmpty];
    }
    return self;
}

@end