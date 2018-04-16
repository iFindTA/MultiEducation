//
//  MEVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MetransPort.pbobjc.h"
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

- (void)postData:(NSData *)data hudEnable:(BOOL)hud success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    NSString *uuidToken = [MEVM createUUID];
    CmdSignPb *transPort = [[CmdSignPb alloc] init];
    [transPort setCmdCode:@"SESSION_POST"];
    [transPort setToken:uuidToken];
    [transPort setSource:data];
    
    NSData *carrier = [transPort data];
    
    [[PBService shared] POSTData:carrier classIdentifier:self.class hudEnable:hud success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resObj) {
        NSLog(@"res:%@", resObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error.description);
    }];
}

@end
