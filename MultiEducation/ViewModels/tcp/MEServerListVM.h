//
//  MEServerListVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "METCPService.h"
#import "MeserverList.pbobjc.h"

@interface MEServerListVM : MEVM

/**
 获取在线服务器列表 并链接长链接
 */
+ (void)fetchOnlineServerList;

@end
