//
//  SGEventForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGEventForm.h"

@implementation SGEventForm

- (id)init {
    if (self = [super init]) {
        _date = [NSDate date];
        _isTournament = NO;
    }
    return self;
}

- (id)init:(Event *)event {
    if (self = [super init]) {
        _event = event;
        _name = _event.name;
        _location = _event.location;
        _date = _event.date;
        _isTournament = [_event.isTournament boolValue];
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