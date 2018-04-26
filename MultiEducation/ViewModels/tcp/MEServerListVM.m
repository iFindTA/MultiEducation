//
//  MEServerListVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEServerListVM.h"

@implementation MEServerListVM

- (NSString *)cmdCode {
    return @"SERVER_LIST";
}

+ (void)fetchOnlineServerList {
    MEServerListVM *vm = [[MEServerListVM alloc] init];
    //weakify(self)
    [vm postData:[NSData data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;//strongify(self)
        MEServerList *list = [MEServerList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
        } else {
            NSArray<MESocketServer*>*servers = list.socketServerArray.copy;
            for (MESocketServer *s in servers) {
                [[METCPService shared] addServerHost:s.host port:s.port];
            }
            [[METCPService shared] connectWithcompletion:^(NSError * _Nullable error) {
                NSLog(@"socket-tcp link error:%@", error);
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

@end
