//
//  METCPService.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface METCPService : NSObject

/**
 share instance for singletone
 */
+ (instancetype)shared;

/**
 connect to host&port

 @param host for connection
 @param port for connection
 @param completion callback
 */
- (void)connect2Host:(NSString *)host port:(uint8_t)port completion:(void(^_Nullable)(NSError * _Nullable))completion;

/**
 handle system send data
 */
- (void)handleSystemSocketData:(void(^_Nullable)(NSData * _Nullable))completion;

/**
 fetch or sync data with remote process
 
 @param data real pb-data
 @param hud whether show or not
 @param success callback
 @param failure callback
 */
- (void)writeData:(NSData * _Nonnull)data hudEnable:(BOOL)hud success:(void(^_Nullable)(NSData * _Nullable resObj))success failure:(void (^_Nullable)(NSError * _Nonnull error))failure;

@end

NS_ASSUME_NONNULL_END
