//
//  AES256Encryption.m
//  semo
//
//  Created by iMac007 on 18/06/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

#import "AES256Encryption.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"

@implementation AES256Encryption

#pragma mark - AES256
+(NSString *)encryptAES256String:(NSString *)targetStr key:(NSString *)key {
    NSData *cipherData = [[targetStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    
    NSString *base64Text;
    
    if ([cipherData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64Text = [cipherData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64Text = [cipherData base64Encoding];                              // pre iOS7
    }

    return base64Text;
}

+(NSString *)decrptAES256String:(NSString *)value key:(NSString *)key {
//    AES256DecryptWithKey
    NSString *result = [value AES256DecryptWithKey:key];
    return result;
}

#pragma mark - AES128
+(NSString *)encryptAES128String:(NSString *)targetStr key:(NSString *)key {
    NSData *cipherData = [[targetStr dataUsingEncoding:NSUTF8StringEncoding] AES128DecryptedDataWithKey:key];
    
    NSString *base64Text;
    
    if ([cipherData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64Text = [cipherData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64Text = [cipherData base64Encoding];                              // pre iOS7
    }

    return base64Text;
}

+(NSString *)decrptAES128String:(NSString *)value key:(NSString *)key {
    NSString *result = [value AES128DecryptWithKey:key];
    return result;
}

@end
