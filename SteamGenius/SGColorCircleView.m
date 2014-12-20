//
//  SGColorCircleView.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/8/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGColorCircleView.h"

@implementation SGColorCircleView

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    //self.layer.borderWidth = 2.f;
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    _color == nil ? _color = [UIColor blackColor]: nil ;
    CGContextSetFillColorWithColor(ctx, _color.CGColor);
    CGContextFillPath(ctx);
}

@end