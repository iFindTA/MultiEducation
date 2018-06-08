//
//  MEIMService.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEIMService : NSObject

/**
 share instance for singletone
 */
+ (instancetype)shared;

/**
 start rongyun im service
 */
- (void)startRongIMService;

/**
 stop rongyun im service
 */
- (void)stopRongIMService;

/**
 刷新本地用户信息
 */
- (void)refreshLocalUserInfo;

@end
