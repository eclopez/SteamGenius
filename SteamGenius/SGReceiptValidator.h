//
//  SGReceiptValidator.h
//  SteamGenius
//
//  Created by Erik Lopez on 1/29/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SGReceiptValidator : NSObject

+ (BOOL)validateReceipt:(SKPaymentTransaction *)transaction;
+ (BOOL)performReceiptValidation;

@end
