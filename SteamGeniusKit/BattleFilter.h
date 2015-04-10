//
//  BattleFilter.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/25/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BattleFilter : NSManagedObject

@property (nonatomic, retain) NSString * displayText;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) id predicate;

@end
