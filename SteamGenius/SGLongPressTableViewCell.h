//
//  SGLongPressTableViewCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import UIKit;

@class SGLongPressTableViewCell;

@protocol SGLongPressTableViewCellDelegate <NSObject>

@optional
- (void)handleLongPress:(SGLongPressTableViewCell *)cell;
@end

@interface SGLongPressTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <SGLongPressTableViewCellDelegate> delegate;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end
