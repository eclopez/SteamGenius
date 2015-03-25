//
//  SGOpponentForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import Foundation;
@import SteamGeniusKit;
#import "FXForms.h"

@interface SGOpponentForm : NSObject <FXForm>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Opponent *opponent;

- (id)init:(Opponent *)opponent;

@end
