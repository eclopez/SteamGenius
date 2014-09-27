//
//  SGEventForm.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGEventForm.h"

@implementation SGEventForm

- (NSDictionary *)nameField {
    return @{ FXFormFieldDefaultValue: self.event ? (self.event.name ? self.event.name : @"") : @"" };
}

- (NSDictionary *)locationField {
    return @{ FXFormFieldDefaultValue: self.event ? (self.event.location ? self.event.location : @"") : @"" };
}

- (NSDictionary *)dateField {
    return @{ FXFormFieldDefaultValue: self.event ? (self.event.date ? (NSDate *)self.event.date : @"") : [NSDate date] };
}

- (NSDictionary *)isTournamentField {
    // TODO DEFAULT VAL WHEN EDITING
    return @{ FXFormFieldHeader: @"",
              FXFormFieldTitle: @"Tournament?",
              FXFormFieldDefaultValue: @1 };
}

- (NSArray *)excludedFields {
    return @[ @"event" ];
}

@end
