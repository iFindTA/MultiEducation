//
//  PBMacros.m
//  MultiEducation
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
    //return @"http://192.168.1.199:8080";
    return @"http://101.132.33.243:443";
#else
    return @"http://101.132.33.243:443";
#endif
}

+ (NSString *)webHost {
    return @"http://ost.x16.com/open/res";
}

+ (NSString *)umengAppKey {
    return @"5aa770eaa40fa32b340000e1";
}

+ (NSString *)shareQQKey {
    return @"1106955313";
}

+ (NSString *)shareQQSecret {
    return @"WkPjVnfD6UOuAckM";
}

+ (NSString *)shareWeiChatKey {
    return @"wxc7c3b807d2164893";
}

+ (NSString *)shareWeiChatSecret {
    return @"0e77ed9dcc8080e8853cec4ec20499cc";
}

+ (NSString *)shareAppIcon {
    return @"AppIcon";
}

+ (NSString *)rongIMAppKey {
    return @"6tnym1br64577";
}

+ (NSString *)appLookupURI {
    return @"http://itunes.apple.com/lookup?id=1105294803";
}

+ (NSString *)appDownloadURI {
    return @"https://itunes.apple.com/cn/app/asos-zhong-guo/id1105294803?mt=8";
}

+ (NSString *)qrCodeShareURI {
    return @"http://app.chinaxqjy.com";
}

@end
