//
//  UIDevice+PBHelper.m
//  NHUtilSetsPro
//
//  Created by hu jiaju on 16/4/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "UIDevice+PBHelper.h"
#import "sys/utsname.h"
#import <sys/mount.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <mach/mach.h>
#import <mach-o/arch.h>
#import <net/if.h>
#import <ifaddrs.h>

@implementation UIDevice (PBHelper)

+(NSString *)getSysInfoByName:(char *)typeSpecifier{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

//获取平台信息
+(NSString *)pb_platform{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    //    NSLog(@"固件版本：%@",result);
    // 模拟器
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    // iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA/Verizon/Sprint)";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,1"])    return @"iPhone 8 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,4"])    return @"iPhone 8 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,3"])    return @"iPhone X (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,6"])    return @"iPhone X (GSM)";
    
    // iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    // iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad PRO (12.9)";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad PRO (12.9)";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad PRO (9.7)";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad PRO (9.7)";
    if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad 5";
    if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad 5";
    
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad PRO 2 (12.9)";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad PRO 2 (12.9)";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad PRO (10.5)";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad PRO (10.5)";
    
    return deviceModel;
}

+ (BOOL)pb_isX {
#if DEBUG
    CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;
    if (mainHeight >= 800) {
        return true;
    }
#endif
    NSString *model = [self pb_platform];
    NSRange range = [model rangeOfString:@"iPhone X"];
    return range.location != NSNotFound;
}

@end
