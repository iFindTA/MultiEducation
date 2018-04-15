//
//  MEUser.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUser.h"

@implementation MEUser

- (id)init {
    self = [super init];
    if (self) {
        _role = MEUserRoleVisitor;
        _state = MEUserStateOffline;
        _keepWatchingDuration = 0.f;
    }
    return self;
}

@end
