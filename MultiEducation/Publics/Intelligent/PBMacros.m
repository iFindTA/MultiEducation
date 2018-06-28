//
//  PBMacros.m
//  MultiIntelligent
//
//  Created by nanhu on 2018/6/28.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation PBMacros

+ (NSString *)env {
#if DEBUG
    return @"lan";
#else
    return @"prod";
#endif
}

+ (NSString *)apiURI {
#if DEBUG
    return @"http://192.168.1.199:8080";
#else
    return @"http://dv3.api.x16.com:80";
#endif
}

+ (NSString *)webHost {
    return @"http://ost.x16.com/open/res";
}

+ (NSString *)umengAppKey {
    return @"5b2b61dff29d9803fc00002a";
}

+ (NSString *)rongIMAppKey {
    return @"82hegw5u8yrnx";
}

@end
