//
//  MEUserVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"

@interface MEUserVM ()

@property (nonatomic, strong, readwrite) MEPBUser *usr;

@property (nonatomic, strong) MEPBSignIn *siginPb;

@end

@implementation MEUserVM

#pragma mark --- Override

- (NSString *)cmdVersion {
    return @"2";
}

- (NSString *)cmdCode {
    return SESSION_POST;
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithModel:(MEPBUser *)usr {
    NSAssert(usr != nil, @" could not initialized by nil!");
    return [[self alloc] initWithUsr:usr];
}

- (id)initWithUsr:(MEPBUser *)usr {
    self = [super init];
    if (self) {
        _usr = usr;
    }
    return self;
}

+ (instancetype)vmWithPB:(MEPBSignIn *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(MEPBSignIn *)pb {
    self = [super init];
    if (self) {
        _siginPb = pb;
    }
    return self;
}

+ (MEPBUser * _Nullable)fetchLatestSignedInUser {
    //TODO:处理已登录用户相关逻辑
    NSArray <MEPBUser*> *usrs = [WHCSqlite query:MEPBUser.class order:@"signtimestamp by desc" limit:@"1"];
    if (usrs.count > 0) {
        return [usrs lastObject];
    }
    return nil;
}

+ (BOOL)whetherExistValidSignedInUser {
    BOOL ret = false;
    //TODO:处理已登录用户相关逻辑
    NSArray <MEPBUser*> *usrs = [WHCSqlite query:MEPBUser.class];
    
    return ret;
}

#pragma mark --- setter & getter

- (MEUserRole)userRole {
    return self.usr.userType;
}

@end
