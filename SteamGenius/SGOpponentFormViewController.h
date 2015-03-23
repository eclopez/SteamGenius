//
//  SGOpponentFormViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import SteamGeniusKit;
#import "FXForms.h"

@interface SGOpponentFormViewController : FXFormViewController <FXFormFieldViewController>

@property (strong, nonatomic) Opponent *object;

@end