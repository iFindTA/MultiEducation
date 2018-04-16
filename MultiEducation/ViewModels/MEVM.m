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

- (void)postData:(NSData *)data cmdCode:(NSString *)cmdCode operationCode:(NSString *)opCode hudEnable:(BOOL)hud success:(void (^)(NSData * _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    
    
    MECarrierPB *carrier = [[MECarrierPB alloc] init];
    /**
     *  uuid for unique request
     */
//    NSString *uuidToken = [MEVM createUUID];
//    [carrier setToken:uuidToken];
    //[carrier setCmdCode:@"SESSION_POST"];
    [carrier setCmdCode:cmdCode];
    [carrier setReqCode:opCode];
    [carrier setSource:data];
    
    NSData *signedData = [carrier data];
    [[PBService shared] POSTData:signedData classIdentifier:self.class hudEnable:hud success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resObj) {
        if (resObj) {
            if ([resObj isKindOfClass:[NSData class]]||[resObj isMemberOfClass:[NSData class]]) {
                NSData *responseData = (NSData *)resObj;
                NSError *err;
                MECarrierPB *responseCarrier = [MECarrierPB parseFromData:responseData error:&err];
                if (err && failure) {
                    failure(err);
                } else {
                    if (success) {
                        success((responseCarrier.source));
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

@end
