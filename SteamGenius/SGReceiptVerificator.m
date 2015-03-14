//
//  SGReceiptVerificator.m
//  SteamGenius
//
//  Created by Erik Lopez on 3/13/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGReceiptVerificator.h"

@implementation SGReceiptVerificator

- (void)verifyTransaction:(SKPaymentTransaction *)transaction success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    NSLog(@"VERIFY...");
    // Replace 'true' with bool expression indicating "if receipt is not valid".
    if (false) {
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

@end