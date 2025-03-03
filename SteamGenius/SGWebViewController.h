//
//  SGWebViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 1/5/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import UIKit;
@import WebKit;
#import "FXForms.h"

@interface SGWebViewController : UIViewController <FXFormFieldViewController>

@property (nonatomic, strong) FXFormField *field;
@property (nonatomic) WKWebView *web;

@end
