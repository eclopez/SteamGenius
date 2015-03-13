//
//  SGBaseVerify.m
//  SteamGenius
//
//  Created by Erik Lopez on 3/1/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGBaseVerify.h"
//#import "RMStoreKeychainPersistence.h"
//#import "checkreceipt.h"
//#import "iapreceipt.h"

@implementation SGBaseVerify

/*- (void)verifyTransaction:(SKPaymentTransaction *)transaction success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    NSLog(@"*MY* VERIFY TRANSACTION!!");
    NSArray *identifiers = @[@"com.eriklopez.steamgenius.premium", @"com.eriklopez.steamgenius.removeads"];
    
    // The validation code that enumerates the InApp purchases
    SGBase_CheckInAppPurchasesAndReceipt(identifiers, ^(NSDictionary *receipt_dict, NSString *identifier, BOOL isPresent, NSDictionary *purchaseInfo) {
        NSLog(@"-> %@", [receipt_dict objectForKey:SGBase_RECEIPT_ATTRIBUTETYPE_ORIGINAL_APPLICATION_VERSION]);
        if (isPresent) {
            NSLog(@">>> %@ x %d", identifier, [[purchaseInfo objectForKey:SGBase_INAPP_ATTRIBUTETYPE_QUANTITY] intValue]);
            successBlock:;
        } else {
            NSLog(@">>> %@ missing", identifier);
            failureBlock:[NSError errorWithDomain:nil code:112 userInfo:nil];
        }
    }, self);
    
//    RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
//    const BOOL verified = [self verifyTransaction:transaction inReceipt:receipt success:successBlock failure:nil]; // failureBlock is nil intentionally. See below.
//    if (verified) return;
//    
//    // Apple recommends to refresh the receipt if validation fails on iOS
//    [[RMStore defaultStore] refreshReceiptOnSuccess:^{
//        RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
//        [self verifyTransaction:transaction inReceipt:receipt success:successBlock failure:failureBlock];
//    } failure:^(NSError *error) {
//        [self failWithBlock:failureBlock error:error];
//    }];
}

#pragma SKRequestDelegate Methods

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"There was an error during refresh request.");
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSLog(@"Found %d", [[NSFileManager defaultManager] fileExistsAtPath:[url path]]);
    
    // Perform another receipt validation to be sure if the user presses cancel
    // To avoid an infinite loop, you may implement a counter
    // You may also use dispatch_after to postpone the retry
    dispatch_async(dispatch_get_main_queue(), ^{
        SGCheck_CheckReceipt(self);
    });
}

#pragma Private Methods

- (void)failWithBlock:(void (^)(NSError *error))failureBlock message:(NSString*)message
{
    NSError *error = [NSError errorWithDomain:RMStoreErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
    [self failWithBlock:failureBlock error:error];
}

- (void)failWithBlock:(void (^)(NSError *error))failureBlock error:(NSError*)error
{
    if (failureBlock)
    {
        failureBlock(error);
    }
}*/

@end
