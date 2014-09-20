//
//  Battle.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caster, Event, Opponent, Result, Scenario;

@interface Battle : NSManagedObject

@property (nonatomic, retain) NSNumber * armyPoints;
@property (nonatomic, retain) NSNumber * controlPoints;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * killPoints;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Opponent *opponent;
@property (nonatomic, retain) Caster *opponentCaster;
@property (nonatomic, retain) Caster *playerCaster;
@property (nonatomic, retain) Result *result;
@property (nonatomic, retain) Scenario *scenario;

@end
