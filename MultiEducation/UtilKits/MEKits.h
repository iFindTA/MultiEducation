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

#pragma mark --- User Abouts

/**
 当前用户所关联的所有班级
 */
+ (NSArray<MEPBClass*>*)fetchCurrentUserMultiClasses;

/**
 当前用户是否关联了多个班级
 */
+ (BOOL)whetherCurrentUserHaveMulticastClasses;

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
+ (UIBarButtonItem *)backBarWithColor:(UIColor *)color target:(nullable id)target withSelector:(nullable SEL)selector;
+ (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color target:(nullable id)target eventSelector:(nullable SEL)selector;
+ (UIBarButtonItem *)barWithTitle:(NSString *)title color:(UIColor *)color target:(nullable id)target eventSelector:(nullable SEL)selector ;
+ (UIBarButtonItem *)barWithImage:(UIImage *)image target:(id)target eventSelector:(SEL)selector;

#pragma mark --- handle hud message

+ (void)handleError:(NSError *)err;

+ (void)handleSuccess:(NSString *)hud;

#pragma mark --- User Token Refresh

/**
 app再次进入前台 超过时间间隔需要刷新token 如七牛上传token
 */
+ (void)refreshUserSessiontoken;

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

@end

NS_ASSUME_NONNULL_END
