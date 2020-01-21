//
//  NSString+url.m
//  KSW2_CS_Sample
//
//  Created by RaonSecure on 2016. 1. 12..
//  Copyright © 2016년 RaonSecure. All rights reserved.
//

#import "NSString+url.h"

@implementation NSString (url)

//http 전송에서 파라미터에 한글이나 특수문자를 보내면 데이터가 바르게 전달되지 않는다. 그래서 URLEncoding을 해서 전송해야하는데 NSString 자체에는 URLEncoding 메소드가 존재하지 않는다.

+ (NSString *)urlEncode:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)str,
                                                                                              NULL,
                                                                                              CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                              kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)urlDecode:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)str,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}

@end
