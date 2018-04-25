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

- (void)startRongIMService;

- (void)stopRongIMService;

@end
