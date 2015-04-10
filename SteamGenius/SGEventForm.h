//
//  SGEventForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
@import SteamGeniusKit;

@interface SGEventForm : NSObject<FXForm>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isTournament;
@property (strong, nonatomic) Event *event;

- (id)init:(Event *)event;

@end
