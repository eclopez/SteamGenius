//
//  SGPurchaseValidation.m
//  SteamGenius
//
//  Created by Erik Lopez on 5/3/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGPurchaseValidation.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"

#define kSteamGeniusPremiumIdentifier @"com.eriklopez.steamgenius.premium"
#define kSteamGeniusRemoveAdsIdentifier @"com.eriklopez.steamgenius.adremoval"
#define kSteamGeniusCustomFactionIconsIdentifier @"com.eriklopez.steamgenius.customfactionicons"

@implementation SGPurchaseValidation

#pragma mark - Public Methods

+ (BOOL)isPremiumPurchased
{
    return [self checkPurchase:kSteamGeniusPremiumIdentifier];
}

+ (BOOL)isAdRemovalPurchased
{
    return [self checkPurchase:kSteamGeniusRemoveAdsIdentifier];
}

+ (BOOL)isCustomFactionIconsPurchased
{
    return [self checkPurchase:kSteamGeniusCustomFactionIconsIdentifier];
}

#pragma mark - Private Methods

+ (BOOL)checkPurchase:(NSString *)productId
{
    RMStoreKeychainPersistence *persist = [RMStore defaultStore].transactionPersistor;
    NSArray *purchases = [[persist purchasedProductIdentifiers] allObjects];
    return [purchases containsObject:productId];
}

@end
