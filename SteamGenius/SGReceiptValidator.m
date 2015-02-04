//
//  SGReceiptValidator.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/29/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGReceiptValidator.h"
#import "RMStoreAppReceiptVerificator.h"
#import <OpenSSL/bio.h>
#import <OpenSSL/pkcs7.h>
#import <OpenSSL/objects.h>
#import <OpenSSL/x509.h>

#define kFruityPebbles @"com.eriklopez.SteamGenius"
#define kRaisinBran @"2"

@implementation SGReceiptValidator

+ (BOOL)validateReceipt:(SKPaymentTransaction *)transaction {
    RMStoreAppReceiptVerificator *_verify = [[RMStoreAppReceiptVerificator alloc] init];
    [_verify verifyTransaction:transaction success:^(void) {
        NSLog(@"ALERT! We did... something.");
    }failure:^(NSError *error) {
        NSLog(@"ALERT! We didn't do anything.");
    }];
    return NO;
}







+ (BOOL)performReceiptValidation
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *receiptUrl = [mainBundle appStoreReceiptURL];
    NSError *receiptError;
    BOOL isPresent = [receiptUrl checkResourceIsReachableAndReturnError:&receiptError];
    
    if (!isPresent) {
        
    }
    
    if (isPresent) {
        // Load the receipt file
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        
        // Create a memory buffer to extract the PKCS #7 container
        BIO *receiptBIO = BIO_new(BIO_s_mem());
        BIO_write(receiptBIO, [receiptData bytes], (int) [receiptData length]);
        PKCS7 *receiptPKCS7 = d2i_PKCS7_bio(receiptBIO, NULL);
        if (!receiptPKCS7) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO IDEA!");
            return NO;
        }
        
        // Check that the container has a signature
        if (!PKCS7_type_is_signed(receiptPKCS7)) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO SIGNATURE ON DA CONTAINER");
            return NO;
        }
        
        // Check that the signed container has actual data
        if (!PKCS7_type_is_data(receiptPKCS7->d.sign->contents)) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO DATA IN DA CONTAINER!");
            return NO;
        }
        
        // Load the Apple Root CA (downloaded from https://www.apple.com/certificateauthority/)
        NSURL *appleRootURL = [[NSBundle mainBundle] URLForResource:@"AppleIncRootCertificate" withExtension:@"cer"];
        NSData *appleRootData = [NSData dataWithContentsOfURL:appleRootURL];
        BIO *appleRootBIO = BIO_new(BIO_s_mem());
        BIO_write(appleRootBIO, (const void *) [appleRootData bytes], (int) [appleRootData length]);
        X509 *appleRootX509 = d2i_X509_bio(appleRootBIO, NULL);
        
        // Create a certificate store
        X509_STORE *store = X509_STORE_new();
        X509_STORE_add_cert(store, appleRootX509);
        
        // Be sure to load the digests before the verification
        OpenSSL_add_all_digests();
        
        // Check the signature
        int result = PKCS7_verify(receiptPKCS7, NULL, store, NULL, NULL, 0);
        if (result != 1) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: YO SIGNATURE SUCKED.");
            return NO;
        }
        
        // Get a pointer to the ASN.1 payload
        ASN1_OCTET_STRING *octets = receiptPKCS7->d.sign->contents->d.data;
        const unsigned char *ptr = octets->data;
        const unsigned char *end = ptr + octets->length;
        const unsigned char *str_ptr;
        
        int type = 0, str_type = 0;
        int xclass = 0, str_xclass = 0;
        long length = 0, str_length = 0;
        
        // Store for the receipt information
        NSString *bundleIdString = nil;
        NSString *bundleVersionString = nil;
        NSData *bundleIdData = nil;
        NSData *hashData = nil;
        NSData *opaqueData = nil;
        NSDate *expirationDate = nil;
        
        // Date formatter to handle RFC 3339 dates in GMT time zone
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        // Decode payload (a SET is expected)
        ASN1_get_object(&ptr, &length, &type, &xclass, end - ptr);
        if (type != V_ASN1_SET) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: SET NO FOUND.");
            return NO;
        }
        
        while (ptr < end) {
            ASN1_INTEGER *integer;
            
            // Parse the attribute sequence (a SEQUENCE is expected)
            ASN1_get_object(&ptr, &length, &type, &xclass, end - ptr);
            if (type != V_ASN1_SEQUENCE) {
                // Validation fails
                NSLog(@"VALIDATION FAILED: Y U NO SEQUENCE?.");
                return NO;
            }
            
            const unsigned char *seq_end = ptr + length;
            long attr_type = 0;
            long attr_version = 0;
            
            // Parse the attribute type (an INTEGER is expected)
            ASN1_get_object(&ptr, &length, &type, &xclass, end - ptr);
            if (type != V_ASN1_INTEGER) {
                // Validation fails
                NSLog(@"VALIDATION FAILED: NO INTEGER!");
                return NO;
            }
            integer = c2i_ASN1_INTEGER(NULL, &ptr, length);
            attr_type = ASN1_INTEGER_get(integer);
            ASN1_INTEGER_free(integer);
            
            // Parse the attribute version (an INTEGER is expected)
            ASN1_get_object(&ptr, &length, &type, &xclass, end - ptr);
            if (type != V_ASN1_INTEGER) {
                // Validation fails
                NSLog(@"VALIDATION FAILED: NO INTEGER2!");
                return NO;
            }
            integer = c2i_ASN1_INTEGER(NULL, &ptr, length);
            attr_version = ASN1_INTEGER_get(integer);
            ASN1_INTEGER_free(integer);
            
            // Check the attribute value (an OCTET STRING is expected)
            ASN1_get_object(&ptr, &length, &type, &xclass, end - ptr);
            if (type != V_ASN1_OCTET_STRING) {
                // Validation fails
                NSLog(@"VALIDATION FAILED: NO OCTET STRING!");
                return NO;
            }
            
            switch (attr_type) {
                case 2:
                    // Bundle identifier
                    str_ptr = ptr;
                    ASN1_get_object(&str_ptr, &str_length, &str_type, &str_xclass, seq_end - str_ptr);
                    if (str_type == V_ASN1_UTF8STRING) {
                        // We store both the decoded string and the raw data for later
                        // The raw is data will be used when computing the GUID hash
                        bundleIdString = [[NSString alloc] initWithBytes:str_ptr length:str_length encoding:NSUTF8StringEncoding];
                        bundleIdData = [[NSData alloc] initWithBytes:(const void *)ptr length:length];
                    }
                    break;
                    
                case 3:
                    // Bundle version
                    str_ptr = ptr;
                    ASN1_get_object(&str_ptr, &str_length, &str_type, &str_xclass, seq_end - str_ptr);
                    if (str_type == V_ASN1_UTF8STRING) {
                        // We store the decoded string for later
                        bundleVersionString = [[NSString alloc] initWithBytes:str_ptr length:str_length encoding:NSUTF8StringEncoding];
                    }
                    break;
                    
                case 4:
                    // Opaque value
                    opaqueData = [[NSData alloc] initWithBytes:(const void *)ptr length:length];
                    break;
                    
                case 5:
                    // Computed GUID (SHA-1 Hash)
                    hashData = [[NSData alloc] initWithBytes:(const void *)ptr length:length];
                    break;
                    
                case 21:
                    // Expiration date
                    str_ptr = ptr;
                    ASN1_get_object(&str_ptr, &str_length, &str_type, &str_xclass, seq_end - str_ptr);
                    if (str_type == V_ASN1_IA5STRING) {
                        // The date is stored as a string that needs to be parsed
                        NSString *dateString = [[NSString alloc] initWithBytes:str_ptr length:str_length encoding:NSASCIIStringEncoding];
                        expirationDate = [formatter dateFromString:dateString];
                    }
                    break;
                    
                    // You can parse more attributes...
                    
                default:
                    break;
            }
            
            // Move past the value
            ptr += length;
        }
        
        // Be sure that all information is present
        if (bundleIdString == nil ||
            bundleVersionString == nil ||
            opaqueData == nil ||
            hashData == nil) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO ALL INFORMATION!");
            return NO;
        }
        
        // Check the bundle identifier
        if (![bundleIdString isEqualToString:kFruityPebbles]) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO EQUAL BUNDLEIDSTRING!");
            return NO;
        }
        
        // Check the bundle version
        if (![bundleVersionString isEqualToString:kRaisinBran]) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO EQUAL BUNDLEVERSIONSTRING!");
            return NO;
        }
        
        NSUUID *vendorIdentifier = [[UIDevice currentDevice] identifierForVendor];
        uuid_t uuid;
        [vendorIdentifier getUUIDBytes:uuid];
        NSData *guidData = [NSData dataWithBytes:(const void *)uuid length:16];
        
        unsigned char hash[20];
        
        // Create a hashing context for computation
        SHA_CTX ctx;
        SHA1_Init(&ctx);
        SHA1_Update(&ctx, [guidData bytes], (size_t) [guidData length]);
        SHA1_Update(&ctx, [opaqueData bytes], (size_t) [opaqueData length]);
        SHA1_Update(&ctx, [bundleIdData bytes], (size_t) [bundleIdData length]);
        SHA1_Final(hash, &ctx);
        
        // Do the comparison
        NSData *computedHashData = [NSData dataWithBytes:hash length:20];
        if (![computedHashData isEqualToData:hashData]) {
            // Validation fails
            NSLog(@"VALIDATION FAILED: NO EQUAL HASH!");
            return NO;
        }
        
        NSLog(@"PASSED!");
        return YES;
    }
    NSLog(@"VALIDATION FAILED: NO RECEIPT!");
    return NO;
}

@end
