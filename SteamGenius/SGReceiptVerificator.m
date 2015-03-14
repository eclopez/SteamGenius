//
//  SGReceiptVerificator.m
//  SteamGenius
//
//  Created by Erik Lopez on 3/13/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGReceiptVerificator.h"
#import "receipt.h"

#define kProductsFile @"SGProducts"

@implementation SGReceiptVerificator

- (void)verifyTransaction:(SKPaymentTransaction *)transaction success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    NSMutableDictionary *purchases;
    NSArray *identifiers = [NSArray arrayWithContentsOfURL:[self getFileUrl:kProductsFile fileType:@"plist"]];
    __block BOOL isValid = NO;
    
    SGBase_CheckInAppPurchases(identifiers, ^(NSString *identifier, BOOL isPresent, NSDictionary *purchaseInfo) {
        isValid = YES;
        if (isPresent) {
            [purchases setValue:[NSNumber numberWithInt:[[purchaseInfo objectForKey:SGBase_INAPP_ATTRIBUTETYPE_QUANTITY] intValue]] forKey:identifier];
        } else {
            NSLog(@">>> %@ missing", identifier);
        }
    }, self);
    
    if (!isValid) {
        if (failureBlock != nil) {
            NSError *error = [NSError errorWithDomain:RMStoreErrorDomain code:0 userInfo:nil];
            failureBlock(error);
        }
        return;
    }
    if (successBlock != nil) {
        successBlock();
    }
    
}

#pragma mark Private Methods

- (NSURL *)getFileUrl:(NSString *)fileName fileType:(NSString *)fileType
{
    return [[NSBundle mainBundle] URLForResource:fileName withExtension:fileType];
}

@end