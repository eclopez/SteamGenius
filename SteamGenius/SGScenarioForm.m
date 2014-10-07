//
//  SGScenarioForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGScenarioForm.h"

@implementation SGScenarioForm

- (id)init:(Scenario *)scenario {
    if (self = [super init]) {
        _scenario = scenario ? scenario : nil;
        _name = scenario ? (scenario.name ? scenario.name : @"") : @"";
    }
    return self;
}

- (NSArray *)excludedFields {
    return @[ @"scenario" ];
}

@end