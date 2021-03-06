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
    //    return @"http://192.168.1.199:8080";
    return @"http://dv3.api.chinaxqjy.com";
#else
    return @"http://dv3.api.chinaxqjy.com";
#endif
}

+ (NSString *)webHost {
    return @"http://ost.x16.com/open/res";
}

+ (NSString *)umengAppKey {
    return @"5b2b61dff29d9803fc00002a";
}

+ (NSString *)shareQQKey {
    return @"1107029716";
}

+ (NSString *)shareQQSecret {
    return @"M3rvWoAboeneeCKN";
}

+ (NSString *)shareWeiChatKey {
    return @"wx3a7f97330b9c5a3f";
}

+ (NSString *)shareWeiChatSecret {
    return @"911e13f30ea954670f684b843eab488f";
}

+ (NSString *)shareAppIcon {
    return @"AppIcon-intelligent";
}

+ (NSString *)rongIMAppKey {
    return @"82hegw5u8yrnx";
}

+ (NSString *)appLookupURI {
    return @"http://itunes.apple.com/lookup?id=1371994833";
}

+ (NSString *)appDownloadURI {
    return @"https://itunes.apple.com/cn/app/asos-zhong-guo/id1371994833?mt=8";
}

+ (NSString *)qrCodeShareURI {
    return @"http://seapp.chinaxqjy.com";
}

@end
