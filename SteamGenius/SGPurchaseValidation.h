//
//  SGPurchaseValidation.h
//  SteamGenius
//
//  Created by Erik Lopez on 5/3/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPurchaseValidation : NSObject

+ (BOOL)isPremiumPurchased;
+ (BOOL)isAdRemovalPurchased;
+ (BOOL)isCustomFactionIconsPurchased;

@end
