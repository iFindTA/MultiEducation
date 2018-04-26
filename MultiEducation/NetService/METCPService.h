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
 账号被蹬回调
 */
@property (nonatomic, copy) void(^_Nullable accountKickoutCallback)(BOOL kicked, NSString *_Nullable msg);

/**
 添加host port
 */
- (void)addServerHost:(NSString *)host port:(uint16_t)port;

/**
 connect to host&port
 */
- (void)connectWithcompletion:(void(^_Nullable)(NSError * _Nullable))completion;

/**
 disconnect for remote server
 */
- (void)disconnect;

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
