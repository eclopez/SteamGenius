//
//  BattleFilter.h
//  Pods
//
//  Created by Erik Lopez on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BattleFilter : NSManagedObject

@property (nonatomic, retain) NSString * displayText;
@property (nonatomic, retain) id predicate;

@end
