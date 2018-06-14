//
//  MEKits.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN
@class MEPBClass;
/**
 公共基础类 主要类方法处理
 */
@interface MEKits : NSObject

/**
 fetch status bar height
 */
+ (NSUInteger)statusBarHeight;

/**
 fetch tabbar height
 */
+ (CGFloat)tabBarHeight;

/**
 uuid
 */
+ (NSString *)createUUID;

/**
 current timeinterval
 */
+ (NSTimeInterval)currentTimeInterval;

/**
 sandbox path
 */
+ (NSString *)sandboxPath;

/**
 获取文件大小
 */
+ (CGFloat)fileSizeWithPath:(NSString *)path;

/**
 assemble full image path
 */
+ (NSString *)imageFullPath:(NSString *)absPath;

/**
 media absolute path
 */
+ (NSString *)mediaFullPath:(NSString *)absPath;

/**
 assmble resource share uri
 */
+ (NSString *)shareResourceUri:(ino64_t)resId type:(int32_t)type;


/**
 filter emoji text

 @param string text
 @return whether has emoji
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


/**
 when iOS > 10.0.0 nine keyboard chinese input, when click 2 - 9, not 2 - 9,      is ➋-➒
 @param string input string
 @return true or false
 */
+ (BOOL)isNineKeyBoard:(NSString*)string;

/**
 get the first pinyin letter of string

 @return A~Z
 */
+ (NSString *)getFirstLetterFromString:(NSString *)aString;


/**
 get dateString from timeStamp

 @param formatter date formatter string
 @param timeStamp time
 @return dateString
 */
+ (NSString *)timeStamp2DateStringWithFormatter:(NSString *)formatter timeStamp:(int64_t)timeStamp;


/**
 get timeStamp from dateString

 @param formatter formatter
 @param dateStr dateString
 @return timeStamp
 */
+ (int64_t)DateString2TimeStampWithFormatter:(NSString *)formatter dateStr:(NSString *)dateStr;

#pragma mark --- User Abouts

/**
 当前用户所关联的所有班级
 */
+ (NSArray<MEPBClass*>*)fetchCurrentUserMultiClasses;

/**
 当前用户session-token
 */
+ (NSString * _Nullable)fetchCurrentUserSessionToken;

/**
 当前用户是否关联了多个班级
 */
+ (BOOL)whetherCurrentUserHaveMulticastClasses;


/**
 获取用户本地缓存图片地址
 */
+ (NSString *)currentUserDownloadPath;

#pragma mark --- Cordova abouts

/**
 准备Cordova环境变量
 */
+ (void)configureCordovaEnv;

/**
 unzip Cordova resource to documents/www path
 */
+ (BOOL)UnzipCordovaResources;

/**
 update Cordova resource packets
 */
+ (void)updateCordovaResourcePacket;

#pragma mark --- UINavigationBar Items

+ (UIBarButtonItem *)barSpacer;
+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target;
+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target action:(SEL _Nullable)selector;
+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target color:(UIColor *_Nullable)color;
+ (UIBarButtonItem *)barWithUnicode:(NSString *)iconCode color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector;
+ (UIBarButtonItem *)barWithUnicode:(NSString *)iconCode title:(NSString*_Nullable)title color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector;
+ (UIBarButtonItem *)barWithTitle:(NSString *)title color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector;
+ (UIBarButtonItem *)barWithImage:(UIImage *)image target:(id)target eventSelector:(SEL)selector;

#pragma mark --- handle hud message

+ (void)handleError:(NSError *)err;

+ (void)handleSuccess:(NSString *)hud;

/**
 底部提示信息
 */
+ (void)makeToast:(NSString *)info;

/**
 顶部提示信息
 */
+ (void)makeTopToast:(NSString *)info;

#pragma mark --- User Token Refresh

/**
 app再次进入前台 超过时间间隔需要刷新token 如七牛上传token
 */
+ (void)refreshCurrentUserSessionTokenWithCompletion:(void(^_Nullable)(NSError * _Nullable err))completion;

/**
 进入app获取当前用户的班级所有联系人 避免聊天session界面头像、名字问题
 */
+ (void)fetchContacts4CurrentUser;

#pragma mark --- Max Upload Size

/**
 最大上传限制
 */
+ (float)uploadMaxLimit;

/**
 处理上传的图片

 @param photos 元数据
 @param assets 数据元信息
 @param checkCap 是否检测网盘容量
 @param completion callback回调
 */
+ (void)handleUploadPhotos:(NSArray *)photos assets:(NSArray *)assets checkDiskCap:(BOOL)checkCap completion:(void(^_Nullable)(NSArray <NSDictionary*>* _Nullable images))completion;


/**
 处理上传视频

 @param videos 视频data
 @param checkCap 是否检测网盘剩余容量
 @param completion callback回调
 */
+ (void)handleUploadVideos:(NSArray <NSData *> *)videos checkDiskCap:(BOOL)checkCap completion:(void (^)(NSArray <NSDictionary*>* _Nullable videos))completion;

/**
 压缩image到制定大小以下

 @param image original image
 @param maxLength maxLength that you can accept
 @return image after compress
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/**
 检查iTunes Store版本
 */
+ (void)checkAppStoreOnlineVersion:(void(^_Nullable)(NSDictionary * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
