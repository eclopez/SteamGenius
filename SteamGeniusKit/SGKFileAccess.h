//
//  SGKFileAccess.h
//  SteamGenius
//
//  Created by Erik Lopez on 5/2/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import Foundation;

@interface SGKFileAccess : NSObject

+ (NSURL *)sharedDocumentsDirectory;
+ (NSURL *)sharedIconsDirectory;
+ (BOOL)factionIconExists:(NSString *)factionName;

@end