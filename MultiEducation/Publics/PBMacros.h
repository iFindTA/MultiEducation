//
//  PBMacros.h
//  MultiEducation
//
//  Created by nanhu on 2018/6/28.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBMacros: NSObject

/**
 app env
 */
+ (NSString *)env;

/**
 global base-api uri for resources
 */
+ (NSString *)apiURI;

/**
 global web-share uri host
 */
+ (NSString *)webHost;

/**
 app key for umeng
 */
+ (NSString *)umengAppKey;

/**
 app key for qq
 */
+ (NSString *)shareQQKey;

/**
 secret for qq
 */
+ (NSString *)shareQQSecret;

/**
 ap key for weichat
 */
+ (NSString *)shareWeiChatKey;

/**
 secret for weichat
 */
+ (NSString *)shareWeiChatSecret;

/**
 app icon for share
 */
+ (NSString *)shareAppIcon;

/**
 app key for rong-cloud im
 */
+ (NSString *)rongIMAppKey;

/**
 app uri online for looking-up
 */
+ (NSString *)appLookupURI;

/**
 app uri online for App-Store
 */
+ (NSString *)appDownloadURI;

/**
 app share uri
 */
+ (NSString *)qrCodeShareURI;

@end

NS_ASSUME_NONNULL_END
