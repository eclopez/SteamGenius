//
//  SGEmptyView.h
//  SteamGenius
//
//  Created by Erik Lopez on 1/6/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGEmptyView : UIView

@property (strong, nonatomic) NSAttributedString *attrEmpty;

- (instancetype)initWithFrame:(CGRect)frame emptyMessage:(NSString *)emptyMessage color:(UIColor *)color;

@end