//
//  SGEventForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGEventForm.h"

@implementation SGEventForm

- (id)init:(Event *)event {
    if (self = [super init]) {
        _event = event ? event : nil;
        _name = event ? (event.name ? event.name : @"") : @"";
        _location = event ? (event.location ? event.location : @"") : @"";
        _date = event ? (event.date ? event.date : nil) : [NSDate date];
        _isTournament = event ? (event.isTournament ? YES : NO) : NO;
    }
    return self;
}

- (NSDictionary *)isTournamentField {
    return @{ FXFormFieldHeader: @"",
              FXFormFieldTitle: @"Tournament?" };
}

- (NSArray *)excludedFields {
    return @[ @"event" ];
}

@end
