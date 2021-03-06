//
//  MEVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "MECmdCodes.h"
#import "MEReqCodes.h"
#import "Meuser.pbobjc.h"
#import "Mecarrier.pbobjc.h"
#import "MephoneInfo.pbobjc.h"
#import <Foundation/Foundation.h>
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

@interface MEVM : NSObject

/**
 session token
 */
@property (nonatomic, copy, nullable) NSString *sessionToken;

/**
 命令版本号 默认 1
 */
@property(nonatomic, copy, nullable) NSString * cmdVersion;

/**
 cmd code 参考：MECmdCodes.h 文件
 */
@property(nonatomic, copy, nullable) NSString * cmdCode;

/**
 req code 参考：MEReqCodes.h 文件
 */
@property(nonatomic, copy, nullable) NSString * operationCode;

/**
 reqeust or response msg
 */
@property(nonatomic, copy, nullable) NSString * msg;

/**
 fetch device info
 */
+ (MEPBPhoneInfo * _Nonnull)getDeviceInfo;

/**
 fetch token for current valid user
 */
+ (NSString * _Nullable)fetchUserToken;

+ (MEPBUser * _Nullable)currentUser;

/**
 assemble request

 @param data origin body data
 */
+ (NSData * _Nullable)assembleRequestWithData:(NSData * _Nonnull)data;

/**
 fetch or sync data with remote process

 @param data real pb-data
 @param hud whether show or not
 @param success callback
 @param failure callback
 */
- (void)postData:(NSData * _Nonnull)data hudEnable:(BOOL)hud success:(void(^_Nullable)(NSData * _Nullable resObj))success failure:(void (^_Nullable)(NSError * _Nonnull error))failure;
- (void)postData:(NSData * _Nonnull)data hudEnable:(BOOL)hud useSession:(BOOL)use success:(void (^_Nullable)(NSData * _Nullable resObj))success failure:(void (^_Nullable)(NSError * _Nonnull error))failure;

/**
 fetch paging data according to index and size

 @param data binary data
 @param size page size
 @param index page index
 @param hud whether show
 @param success callback
 @param failure callback
 */
- (void)postData:(NSData *_Nonnull)data pageSize:(int32_t)size pageIndex:(int32_t)index hudEnable:(BOOL)hud success:(void (^_Nullable)(NSData * _Nullable resObj, int32_t totalPages))success failure:(void (^_Nullable)(NSError * _Nonnull error))failure;

@end
