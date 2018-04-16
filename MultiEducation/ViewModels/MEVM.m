//
//  MEVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import <PBService/PBService.h>

@implementation MEVM

+ (NSString *)createUUID {
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
    return udidString;
}

+ (NSString *)fetchUserToken {
    return nil;
}

+ (NSData *)assembleRequestWithData:(NSData *)data {
    return data;
}

- (void)postData:(NSData *)data hudEnable:(BOOL)hud success:(void (^)(NSData * _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    
    
    MECarrierPB *carrier = [[MECarrierPB alloc] init];
    /**
     *  uuid for unique request
     */
//    NSString *uuidToken = [MEVM createUUID];
//    [carrier setToken:uuidToken];
    /**
     *  cmdCode
     */
    NSString *cmdCode = [self cmdCode];
    [carrier setCmdCode:cmdCode];
    /**
     *  reqCode
     */
    NSString *optCode = [self operationCode];
    [carrier setReqCode:optCode];
    /**
     *  real binary data
     */
    [carrier setSource:data];
    //cmd version
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
                    if (success) {
                        success((responseCarrier.source));
                    }
                } else {
                    if (responseCarrier.msg.length > 0) {
                        err = [NSError errorWithDomain:responseCarrier.msg code:-1 userInfo:nil];
                    }
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

@end
