//
//  MEVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
#import <PBService/PBService.h>

@interface MEVM ()

@end

@implementation MEVM

+ (NSString *)createUUID {
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
    return udidString;
}

+ (NSString *)fetchUserToken {
    return nil;
}

+ (MEPBUser *)currentUser {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app.curUser;
}

+ (NSData *)assembleRequestWithData:(NSData *)data {
    return data;
}

+ (MEPBPhoneInfo *)getDeviceInfo {
    
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *subscruberId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model =  [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
    NSString *appVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    MEPBPhoneInfo *info = [[MEPBPhoneInfo alloc] init];
    [info setDeviceId:deviceId];
    [info setSubscriberId:subscruberId];
    [info setModel:model];
    [info setAppVersion:appVersion];
    [info setOsVersion:osVersion];
    [info setBrand:@"iPhone"];
    return info;
}

- (AppDelegate *)app {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app;
}

- (void)postData:(NSData *)data hudEnable:(BOOL)hud success:(void (^)(NSData * _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    [self postData:data hudEnable:hud useSession:true success:success failure:failure];
}

- (void)postData:(NSData *)data hudEnable:(BOOL)hud useSession:(BOOL)use success:(void (^)(NSData * _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
//    if (![SBNetState isReachable]) {
//        NSError *error = [NSError errorWithDomain:@"网络未连接，请检查网络设置！" code:-1 userInfo:nil];
//        if (failure) {
//            failure(error);
//        }
//        return;
//    }
    
    MECarrierPB *carrier = [[MECarrierPB alloc] init];
    /**
     *  uuid for unique request
     */
    //    NSString *uuidToken = [MEVM createUUID];
    //    [carrier setToken:uuidToken];
    /**
     * sessionToken
     */
    NSString *sessionToken = [self sessionToken];
    if (sessionToken.length == 0) {
        sessionToken = self.app.curUser.sessionToken;
    }
    if (!use) {
        sessionToken = nil;
    }
    [carrier setSessionToken:sessionToken];
    /**
     *  cmdCode
     */
    NSString *cmdCode = [self cmdCode];
    [carrier setCmdCode:cmdCode];
    /**
     *  reqCode
     */
    NSString *reqCode = [self operationCode];
    [carrier setReqCode:reqCode];
    /**
     *  msg
     */
    NSString *msg = [self msg];
    [carrier setMsg:msg];
    /**
     *  real binary data
     */
    [carrier setSource:data];
    /**
     *  cmd version
     */
    NSString *cmdVersion = [self cmdVersion];
    [carrier setCmdVersion:cmdVersion];
    
    NSData *signedData = [carrier data];
    [[PBService shared] POSTData:signedData classIdentifier:self.class hudEnable:hud success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resObj) {
        if (resObj) {
            if ([resObj isKindOfClass:[NSData class]]||[resObj isMemberOfClass:[NSData class]]) {
                NSData *responseData = (NSData *)resObj;
                NSError *err;
                MECarrierPB *responseCarrier = [MECarrierPB parseFromData:responseData error:&err];
                if ([responseCarrier.respCode isEqualToString:@"SUCCESS"]) {
                    if (responseCarrier.sessionToken.length > 0) {
                        self.sessionToken = responseCarrier.sessionToken;
                    }
                    if (success) {
                        success((responseCarrier.source));
                    }
                } else {
                    //err message
                    NSString *errMsg = @"未知错误！";
                    if (responseCarrier.msg.length > 0) {
                        errMsg = responseCarrier.msg;
                    }
                    // err cide
                    NSUInteger errCode = -1;
                    if ([responseCarrier.respCode isEqualToString:@"SESSION_EXPIRED"]) {
                        errCode = 401;
                    }
                    err = [NSError errorWithDomain:errMsg code:errCode userInfo:nil];
                    if (failure) {
                        failure(err);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postData:(NSData *)data pageSize:(int32_t)size pageIndex:(int32_t)index hudEnable:(BOOL)hud success:(void (^)(NSData * _Nullable, int32_t))success failure:(void (^)(NSError * _Nonnull))failure {
//    if (![SBNetState isReachable]) {
//        NSError *error = [NSError errorWithDomain:@"网络未连接，请检查网络设置！" code:-1 userInfo:nil];
//        if (failure) {
//            failure(error);
//        }
//        return;
//    }
    
    MECarrierPB *carrier = [[MECarrierPB alloc] init];
    /**
     *  uuid for unique request
     */
    //    NSString *uuidToken = [MEVM createUUID];
    //    [carrier setToken:uuidToken];
    /**
     * sessionToken
     */
    NSString *sessionToken = self.app.curUser.sessionToken;
    [carrier setSessionToken:sessionToken];
    /**
     *  cmdCode
     */
    NSString *cmdCode = [self cmdCode];
    [carrier setCmdCode:cmdCode];
    /**
     *  reqCode
     */
    NSString *reqCode = [self operationCode];
    [carrier setReqCode:reqCode];
    /**
     *  msg
     */
    NSString *msg = [self msg];
    [carrier setMsg:msg];
    /**
     *  pageSize & index
     */
    MEPBPage *page = [[MEPBPage alloc] init];
    [page setPageSize:size];
    [page setCurrentPage:index];
    [carrier setPage:page];
    /**
     *  real binary data
     */
    [carrier setSource:data];
    /**
     *  cmd version
     */
    NSString *cmdVersion = [self cmdVersion];
    [carrier setCmdVersion:cmdVersion];
    
    NSData *signedData = [carrier data];
    [[PBService shared] POSTData:signedData classIdentifier:self.class hudEnable:hud success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resObj) {
        if (resObj) {
            if ([resObj isKindOfClass:[NSData class]]||[resObj isMemberOfClass:[NSData class]]) {
                NSData *responseData = (NSData *)resObj;
                NSError *err;
                MECarrierPB *responseCarrier = [MECarrierPB parseFromData:responseData error:&err];
                if ([responseCarrier.respCode isEqualToString:@"SUCCESS"]) {
                    if (responseCarrier.sessionToken.length > 0) {
                        self.sessionToken = responseCarrier.sessionToken;
                    }
                    if (success) {
                        success((responseCarrier.source), responseCarrier.page.totalPages);
                    }
                } else {
                    //err message
                    NSString *errMsg = @"未知错误！";
                    if (responseCarrier.msg.length > 0) {
                        errMsg = responseCarrier.msg;
                    }
                    // err cide
                    NSUInteger errCode = -1;
                    if ([responseCarrier.respCode isEqualToString:@"SESSION_EXPIRED"]) {
                        errCode = 401;
                    }
                    err = [NSError errorWithDomain:errMsg code:errCode userInfo:nil];
                    if (failure) {
                        failure(err);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark --- 需要被override的methods
- (NSString *)cmdVersion {
    return @"1";
}

- (NSString * _Nullable)cmdCode {
    return @"";
}

- (NSString * _Nullable)operationCode {
    return @"";
}

- (NSString * _Nullable)msg {
    return @"";
}

@end
