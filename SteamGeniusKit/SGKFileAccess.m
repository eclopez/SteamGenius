//
//  SGKFileAccess.m
//  SteamGenius
//
//  Created by Erik Lopez on 5/2/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGKFileAccess.h"

// Constants
#define kAppGroupIdentifier @"group.com.eriklopez.SteamGenius"
#define kSharedIconsDirectoryName @"faction-icons"

@implementation SGKFileAccess

#pragma mark - Shared Documents Directory

+ (NSURL *)sharedDocumentsDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
}

#pragma mark - Faction Icon Files

+ (NSURL *)sharedIconsDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *iconsDirectoryURL = [[self sharedDocumentsDirectory] URLByAppendingPathComponent:kSharedIconsDirectoryName];
    
    BOOL isDirectory;
    NSError *error;
    
    if (![manager fileExistsAtPath:iconsDirectoryURL.path isDirectory:&isDirectory]) {
        if (![manager createDirectoryAtPath:iconsDirectoryURL.path withIntermediateDirectories:YES attributes:nil error:&error]) {
            // HANDLE ERROR
            NSLog(@"Error creating icons directory in app group: %@", error.localizedDescription);
        }
    }
    
    return iconsDirectoryURL;
}

+ (BOOL)factionIconExists:(NSString *)factionName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[[self sharedIconsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", factionName]].path]) {
        return YES;
    }
    return NO;
}

@end
