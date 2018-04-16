//
//  MEVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MECmdCodes.h"
#import "MEReqCodes.h"
#import "Mecarrier.pbobjc.h"
#import <Foundation/Foundation.h>
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

@interface MEVM : NSObject

/**
 命令版本号 默认 1
 */
- (NSString * _Nonnull)cmdVersion;

/**
 cmd code 参考：MECmdCodes.h 文件
 */
- (NSString * _Nullable)cmdCode;

/**
 req code 参考：MEReqCodes.h 文件
 */
- (NSString * _Nullable)operationCode;

/**
 角色
 */
@property (nonatomic, assign) MEUserRole userRole;



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
