//
//  SGDataImport.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import Foundation;
#import "SteamGeniusKit.h"

typedef NS_ENUM(NSInteger, SGEntityType) {
    SGEntityType_Game,
    SGEntityType_Faction,
    SGEntityType_Model,
    SGEntityType_Caster,
    SGEntityType_Result
};

@interface SGDataImport : NSObject

+ (void)importDataForEntityNamed:(NSString *)entityName version:(NSInteger)version entityType:(SGEntityType)entityType plistFileNamed:(NSString *)fileName context:(NSManagedObjectContext *)context;

@end
