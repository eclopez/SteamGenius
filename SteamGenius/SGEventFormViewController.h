//
//  SGEventFormViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "FXForms.h"
#import "Event.h"

@interface SGEventFormViewController : FXFormViewController <FXFormFieldViewController>

@property (strong, nonatomic) Event *object;

@end
