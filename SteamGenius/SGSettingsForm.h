//
//  SGSettingsForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import Foundation;
#import "FXForms.h"

@interface SGSettingsForm : NSObject <FXForm>

@property (nonatomic, copy) NSNumber *theme;
@property (nonatomic, copy) NSString *factionIcons;
@property (strong, nonatomic) NSString *products;
@property (nonatomic, strong) NSString *donate;

@end