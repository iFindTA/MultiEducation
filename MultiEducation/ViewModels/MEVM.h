//
//  MEVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

@interface MEVM : NSObject

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

 @param data binary data
 @param hud whether show hud while request
 @param success callback
 @param failure callback
 */
- (void)postData:(NSData * _Nonnull)data hudEnable:(BOOL)hud success:(void(^_Nullable)(id _Nullable resObj))success failure:(void (^_Nullable)(NSError * _Nonnull error))failure;

@end
