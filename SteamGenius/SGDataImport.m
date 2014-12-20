//
//  SGDataImport.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/19/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGDataImport.h"
#import "AppDelegate.h"
#import "SGGenericRepository.h"
#import "SGRepository.h"
#import "DataVersion.h"

@implementation SGDataImport

+ (void)importDataForEntityNamed:(NSString *)entityName version:(NSInteger)version entityType:(SGEntityType)entityType plistFileNamed:(NSString *)fileName context:(NSManagedObjectContext *)context
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    DataVersion *entityDataVersion;
    NSInteger entityVersion;
    
    DataVersion *dataVersion = [SGGenericRepository findOneEntityOfType:@"DataVersion" entityKey:entityName keyField:@"name" context:context];
    if (dataVersion != nil) {
        entityDataVersion = dataVersion;
    } else {
        entityDataVersion = [SGRepository initWithEntityNamed:entityName version:[NSNumber numberWithInt:0] context:context];
    }
    entityVersion = [entityDataVersion.version intValue];
    
    if (entityVersion < version) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
        for (id d in data) {
            int dVersion = [[d objectForKey:@"version"] intValue];
            if (dVersion > entityVersion && dVersion <= version) {
                switch (entityType) {
                    case SGEntityType_Game:
                        [SGRepository initWithGameNamed:[d objectForKey:@"name"] shortName:[d objectForKey:@"shortName"] context:context];
                        break;
                    case SGEntityType_Faction:
                        [SGRepository initWithFactioNamed:[d objectForKey:@"name"] shortName:[d objectForKey:@"shortName"] color:[d objectForKey:@"color"] imageNamed:[d objectForKey:@"imageName"] releaseOrder:[d objectForKey:@"releaseOrder"] gameNamed:[d objectForKey:@"game"] context:context];
                        break;
                    case SGEntityType_Model:
                        [SGRepository initWithModelNamed:[d objectForKey:@"name"] shortName:[d objectForKey:@"shortName"] incarnation:[NSNumber numberWithInt:[[d objectForKey:@"incarnation"] intValue]] isEpic:[NSNumber numberWithBool:[[d objectForKey:@"isEpic"] boolValue]] isCavalry:[NSNumber numberWithBool:[[d objectForKey:@"isCavalry"] boolValue]] isBattleEngine:[NSNumber numberWithBool:[[d objectForKey:@"isBattleEngine"] boolValue]] context:context];
                        break;
                    case SGEntityType_Caster:
                        for (id f in [d objectForKey:@"factions"]) {
                            [SGRepository initWithModelNamed:[d objectForKey:@"name"] factionName:f context:context];
                        }
                        break;
                    case SGEntityType_Result:
                        [SGRepository initWithResultNamed:[d objectForKey:@"name"] winValue:[NSNumber numberWithInt:[[d objectForKey:@"value"] intValue]] displayOrder:[NSNumber numberWithInt:[[d objectForKey:@"sort"] intValue]] context:context];
                        break;
                }
            }
        }
    }
    [entityDataVersion setValue:[NSNumber numberWithInteger:version] forKey:@"version"];
    [appDelegate saveContext];
}

@end