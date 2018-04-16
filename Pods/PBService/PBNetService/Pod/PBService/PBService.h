//
//  PBService.h
//  PBNetService
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 nanhujiaju. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 network state enumerator
 */
typedef NS_ENUM(NSUInteger, PBNetState) {
    PBNetStateUnknown                      =   1   <<  0,
    PBNetStateUnavaliable                  =   1   <<  1,
    PBNetStateViaWWAN                      =   1   <<  2,
    PBNetStateViaWiFi                      =   1   <<  3
};

@interface PBService : AFHTTPSessionManager

/**
 current net state
 */
@property (nonatomic, assign, readonly) PBNetState netState;

+ (void)configBaseURL:(NSString *)url;

/**
 singletone mode for net service
 */
+ (instancetype)shared;

#pragma mark -- HTTP1.1 Basic/Digest Authorize

#pragma mark -- Request Methods for ProtoBuf

- (void)challengePermissionWithResponse:(void (^)(id _Nullable, NSError * _Nullable))response;

/**
 Post protobuf data

 @param data binary
 @param hud whether show hud while request
 @param success callback
 @param failure callback
 */
- (void)POSTData:(NSData *)data classIdentifier:(Class)cls hudEnable:(BOOL)hud success:(void(^_Nullable)(NSURLSessionDataTask *_Nullable task, id _Nullable resObj))success failure:(void(^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
