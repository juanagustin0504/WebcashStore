//
//  NSString+Utils.h
//  PatternTestApp
//
//  Created by eggtarte on 2015. 10. 27..
//  Copyright © 2015년 eggtarte. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Crypto)

- (NSString*)hexStringWithData:(unsigned char*)data ofLength:(NSUInteger)len;

+ (NSString *)getEncryptKey:(NSString *)key;

- (NSString *)SHA256inputString:(NSString *)inputString;

- (NSString *)SHA256String;

- (NSString *)SHA512String;

- (NSString *)hexStringWithString:(NSString *)plainString;

- (NSString *)base64EncodeWithString:(NSString *)plainString;

- (NSString *)base64EncodeWithData:(NSData *)plainData;

- (NSString *)base64DecodeWithString:(NSString *)Base64String;

- (NSData *)base64DecodeData:(NSString *)Base64String;

@end
