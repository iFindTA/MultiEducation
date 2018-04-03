//
//  PBNetService.h
//  FLKNetServicePro
//
//  Created by nanhujiaju on 2017/7/19.
//  Copyright © 2017年 nanhu. All rights reserved.
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

@interface PBNetService : AFHTTPSessionManager

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

/**
 HTTP/1.1 Basic Author
 
 @param info :info description
 @param key :HTTP Header key
 */
- (void)setAuthorization:(NSString *)info forKey:(NSString *)key;

/**
 HTTP/1.1 Basic Author
 
 @param username usr name
 @param password usr pwd
 */
- (void)setAuthorizationWithUsername:(NSString *)username password:(NSString *)password;

/**
 wether net enabled now
 
 @return result
 */
- (BOOL)netvalid;

#pragma mark -- Cancel Request Method --

/**
 cancel request for path
 
 @param aClass the class
 */
- (void)cancelRequestForClass:(nullable Class)aClass;

/**
 cancel all request in the operation queue
 */
- (void)cancelAllRequest;

/**
 Request method throw GET
 
 @param path uri path for Restful Api
 @param params for the request
 @param cls for the request launched by
 @param view that should be disabled userInterface action while in requesting
 @param hud whether show hud while in requesting
 @param downProgress the progress
 @param success response
 @param failure response
 */
- (void)GET:(NSString *)path parameters:(nullable id)params class:(Class _Nullable)cls view:(UIView * _Nullable)view hudEnable:(BOOL)hud progress:(void (^_Nullable)(NSProgress * _Nonnull progress))downProgress success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

/**
 Normal request method throw POST
 
 @param path the uri path for Restful Api
 @param params for the request
 @param cls for the request launched by
 @param view that should be disabled userInterface action while in requesting
 @param success response
 @param failure response
 */
- (void)POST:(NSString *)path parameters:(nullable id)params class:(Class _Nullable)cls view:(UIView * _Nullable)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask *task, id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 Request method throw PUT
 
 @param path the uri path for Restful Api
 @param params for the request
 @param cls for the request launched by
 @param view request current view
 @param success response
 @param failure response
 */
- (void)PUT:(NSString *)path parameters:(nullable id)params class:(Class _Nullable)cls view:(UIView * _Nullable)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * task,id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * error))failure;

/**
 Request method throw DELETE
 
 @param path the uri path for Restful Api
 @param params for the request
 @param cls for the request launched by
 @param view request current view
 @param success response
 @param failure response
 */
- (void)DELETE:(NSString *)path parameters:(nullable id)params class:(Class _Nullable)cls view:(UIView * _Nullable)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * error))failure;

/**
 应对国内应用第一次启动需拥护授权 联网权限 的bug

 @param response 可选
 */
- (void)challengePermissionWithResponse:(void(^_Nullable)(id _Nullable respo, NSError * _Nullable error))response;

@end

//正常响应 成功code
FOUNDATION_EXPORT unsigned int const PB_NETWORK_RESPONSE_CODE_SUCCESS;

NS_ASSUME_NONNULL_END
