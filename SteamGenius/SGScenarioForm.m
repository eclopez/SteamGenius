//
//  SGScenarioForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGScenarioForm.h"

@implementation SGScenarioForm

- (NSDictionary *)nameField {
    return @{ FXFormFieldDefaultValue: self.scenario ? (self.scenario.name ? self.scenario.name : @"") : @"" };
}

- (NSArray *)excludedFields {
    return @[ @"scenario" ];
}

@end