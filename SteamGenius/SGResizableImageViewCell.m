//
//  SGResizableImageViewCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGResizableImageViewCell.h"

@implementation SGResizableImageViewCell

@synthesize imageViewFrame = _imageViewFrame;

- (void)setImageViewFrame:(CGRect)imageViewFrame
{
    _imageViewFrame = imageViewFrame;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_imageViewFrame.size.width > 0 && _imageViewFrame.size.height > 0) {
        self.imageView.frame = _imageViewFrame;
    }
    
    // Get textLabel frame
    CGRect textlabelFrame = self.textLabel.frame;
    
    // Calculate new width
    CGFloat imageWidth = (_imageViewFrame.origin.x * 2) + _imageViewFrame.size.width;
    textlabelFrame.size.width = textlabelFrame.size.width + textlabelFrame.origin.x - imageWidth;
    
    // Change origin to what we want
    textlabelFrame.origin.x = imageWidth;
    
    // Assign the the new frame to textLabel
    self.textLabel.frame = textlabelFrame;
}

@end
