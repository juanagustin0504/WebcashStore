//
//  NSString+url.h
//  KSW2_CS_Sample
//
//  Created by RaonSecure on 2016. 1. 12..
//  Copyright © 2016년 RaonSecure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (url)

+ (NSString *)urlEncode:(NSString *)str;
+ (NSString *)urlDecode:(NSString *)str;

@end
