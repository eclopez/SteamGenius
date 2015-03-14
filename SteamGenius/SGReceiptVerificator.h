//
//  SGReceiptVerificator.h
//  SteamGenius
//
//  Created by Erik Lopez on 3/13/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "RMStore.h"

@interface SGReceiptVerificator : NSObject <RMStoreReceiptVerificator, SKRequestDelegate>

- (void)verifyTransaction:(SKPaymentTransaction *)transaction success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock;

@end