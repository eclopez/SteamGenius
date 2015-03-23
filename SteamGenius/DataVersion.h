//
//  DataVersion.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/22/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataVersion : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * version;

@end
