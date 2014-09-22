//
//  SGResizableImageViewCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGResizableImageViewCell : UITableViewCell {
    CGRect _imageViewFrame;
}

@property (nonatomic, assign) CGRect imageViewFrame;

@end
