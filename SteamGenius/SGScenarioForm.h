//
//  SGScenarioForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Scenario.h"

@interface SGScenarioForm : NSObject<FXForm>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Scenario *scenario;

@end
