//
//  SGLongPressTableViewCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGLongPressTableViewCell.h"

@implementation SGLongPressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        self.longPressRecognizer.minimumPressDuration = .5;
        [self addGestureRecognizer:self.longPressRecognizer];
    }
    return self;
}

- (void)awakeFromNib {
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    self.longPressRecognizer.minimumPressDuration = .5;
    [self addGestureRecognizer:self.longPressRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Gesture Methods

- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate handleLongPress:self];
    }
}

@end