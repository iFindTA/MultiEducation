//
//  MEUser.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEM.h"

@interface MEUser : MEM

@property (nonatomic, copy) NSString *userID;

/**
 角色
 */
@property (nonatomic, assign) MEUserRole    role;

@property (nonatomic, assign) MEUserState   state;

@property (nonatomic, assign) NSTimeInterval signtimestamp;

/**
 user keep watching timeinterval
 */
@property (nonatomic, assign) NSTimeInterval keepWatchingDuration;

@end
