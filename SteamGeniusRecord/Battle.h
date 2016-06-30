//
//  Battle.h
//  SteamGenius
//
//  Created by Erik Lopez on 4/10/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caster, Event, Opponent, Result, Scenario;

@interface Battle : NSManagedObject

@property (nonatomic, retain) NSNumber * controlPoints;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * killPoints;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * mark3;
@property (nonatomic, retain) NSNumber * opponentControlPoints;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Opponent *opponent;
@property (nonatomic, retain) Caster *opponentCaster;
@property (nonatomic, retain) Caster *playerCaster;
@property (nonatomic, retain) Result *result;
@property (nonatomic, retain) Scenario *scenario;

@end
