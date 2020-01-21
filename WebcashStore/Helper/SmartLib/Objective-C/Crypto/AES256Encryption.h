//
//  AES256Encryption.h
//  semo
//
//  Created by iMac007 on 18/06/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES256Encryption : NSObject
+ (NSString*)encryptAES256String:(NSString *)targetStr  key:(NSString *)key;
+ (NSString *)decrptAES256String:(NSString *)value key:(NSString *)key;

+ (NSString*)encryptAES128String:(NSString *)targetStr  key:(NSString *)key;
+ (NSString *)decrptAES128String:(NSString *)value key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
