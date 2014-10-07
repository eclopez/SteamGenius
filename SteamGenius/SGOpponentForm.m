//
//  SGOpponentForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGOpponentForm.h"

@implementation SGOpponentForm

- (id)init:(Opponent *)opponent {
    if (self = [super init]) {
        _opponent = opponent ? opponent : nil;
        _name = opponent ? (opponent.name ? opponent.name : @"") : @"";
    }
    return self;
}

- (NSArray *)excludedFields {
    return @[ @"opponent" ];
}

@end