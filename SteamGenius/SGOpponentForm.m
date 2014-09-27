//
//  SGOpponentForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGOpponentForm.h"

@implementation SGOpponentForm

- (NSDictionary *)nameField {
    return @{ FXFormFieldDefaultValue: self.opponent ? (self.opponent.name ? self.opponent.name : @"") : @"" };
}

- (NSArray *)excludedFields {
    return @[ @"opponent" ];
}

@end