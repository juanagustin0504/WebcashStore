//
//  NSString+Utils.m
//  PatternTestApp
//
//  Created by eggtarte on 2015. 10. 27..
//  Copyright © 2015년 eggtarte. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Crypto.h"

//#include <openssl/rsa.h>
//#include <openssl/evp.h>
//#include <openssl/bn.h>
//#include <openssl/pem.h>

@implementation NSString (Crypto)

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))
static const NSString *KeyPrefix		= @"webcash";
static char encodingTable[]				= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString*)hexStringWithData:(unsigned char*)data ofLength:(NSUInteger)len{
    NSMutableString *tmp = [NSMutableString string];
    for (NSUInteger i=0; i<len; i++)
        [tmp appendFormat:@"%02x", data[i]];
    return [NSString stringWithString:tmp];
}

- (NSString *)hexStringWithString:(NSString *)plainString {
    unsigned char *tempChar = (unsigned char *)[plainString UTF8String];
    NSString *hexString = [[[NSString alloc] init] hexStringWithData:tempChar ofLength:strlen(tempChar)];
    return hexString;
}

+ (NSString *)getEncryptKey:(NSString *)key {
    NSString *encKey = [KeyPrefix stringByAppendingString:key];
    return [encKey SHA512String];
}

- (NSString *)SHA256inputString:(NSString *)inputString {
    const char* str = [inputString UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)SHA256String {
    const char* str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)SHA512String {
    if(self == nil || [self isEqualToString:@""])
        return nil;
    
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, strlen(str), result);
    
    NSString *ret = [[NSString alloc] init];
    for (NSInteger i = 0; i < 64; i++) {
        ret = [ret stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%02X", result[i]]];
    }
    return ret;
}
- (NSString *)base64EncodeWithString:(NSString *)plainString {
    NSData *aData = [plainString dataUsingEncoding: NSASCIIStringEncoding];
    return [self encode:(const uint8_t*) aData.bytes length:aData.length];
}

- (NSString *)base64EncodeWithData:(NSData *)plainData {
    return [self encode:(const uint8_t*) plainData.bytes length:plainData.length];
}


- (NSString *)base64DecodeWithString:(NSString *)Base64String {
    return [[NSString alloc] initWithData:[self decode:[Base64String cStringUsingEncoding:NSASCIIStringEncoding] length:Base64String.length]encoding:NSUTF8StringEncoding];
}


- (NSData *)base64DecodeData:(NSString *)Base64String {
    return [self decode:[Base64String cStringUsingEncoding:NSASCIIStringEncoding] length:Base64String.length];
}

- (NSString *)encode:(const uint8_t*)input length:(NSInteger)length {
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =					encodingTable[(value >> 18) & 0x3F];
        output[index + 1] =					encodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data
                                 encoding:NSASCIIStringEncoding];
}


- (NSData *)decode:(const char*)string length:(NSInteger)inputLength {
    if ((string == NULL) || (inputLength % 4 != 0)) {
        return nil;
    }
    
    static char decodingTable[128];
    
    memset(decodingTable, 0, ArrayLength(decodingTable));
    for (NSInteger i = 0; i < ArrayLength(encodingTable); i++) {
        decodingTable[encodingTable[i]] = i;
    }
    
    while (inputLength > 0 && string[inputLength - 1] == '=') {
        inputLength--;
    }
    
    NSInteger outputLength = inputLength * 3 / 4;
    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
    uint8_t* output = data.mutableBytes;
    
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < inputLength) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
        char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
        }
    }
    
    return data;
}

@end
