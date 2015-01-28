//
//  SGEmptyView.h
//  SteamGenius
//
//  Created by Erik Lopez on 1/25/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGEmptyView : UIView

@property (strong, nonatomic) UILabel *lblEmpty;

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message textColor:(UIColor *)textColor;

@end
