//
//  NSString+Md5String.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "NSString+Md5String.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Md5String)

+ (NSString *)md5:(nullable NSString *)str {
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

@end
