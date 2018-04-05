//
//  MEUserVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "MEUser.h"

@interface MEUserVM ()

@property (nonatomic, strong, readwrite) MEUser *usr;

@end

@implementation MEUserVM

+ (instancetype)vmWithModel:(MEUser *)usr {
    NSAssert(usr != nil, @" could not initialized by nil!");
    return [[MEUserVM alloc] initWithUsr:usr];
}

- (id)initWithUsr:(MEUser *)usr {
    self = [super init];
    if (self) {
        _usr = usr;
    }
    return self;
}

+ (MEUser * _Nullable)fetchLatestSignedInUser {
    //TODO:处理已登录用户相关逻辑
    NSArray <MEUser*> *usrs = [WHCSqlite query:MEUser.class order:@"signtimestamp by desc" limit:@"1"];
    if (usrs.count > 0) {
        return [usrs lastObject];
    }
    return nil;
}

+ (BOOL)whetherExistValidSignedInUser {
    BOOL ret = false;
    //TODO:处理已登录用户相关逻辑
    NSArray <MEUser*> *usrs = [WHCSqlite query:MEUser.class];
    
    return ret;
}

@end
