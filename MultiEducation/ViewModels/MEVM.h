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
#import "Mecarrier.pbobjc.h"
#import <Foundation/Foundation.h>
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

@interface MEVM : NSObject

/**
 session token
 */
@property (nonatomic, copy, readonly, nullable) NSString *sessionToken;

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
 fetch token for current valid user
 */
+ (NSString * _Nullable)fetchUserToken;

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

@end
