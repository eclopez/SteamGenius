//
//  SGScenarioForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import Foundation;
#import "Scenario.h"
#import "FXForms.h"

@interface SGScenarioForm : NSObject<FXForm>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Scenario *scenario;

- (id)init:(Scenario *)scenario;

@end
