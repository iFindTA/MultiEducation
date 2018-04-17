//
//  MEVerifyCodeVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVerifyCodeVM.h"

@interface MEVerifyCodeVM ()

@property (nonatomic, strong) MEPBSignIn *siginPb;

@end

@implementation MEVerifyCodeVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return CODE_GET;
}

#pragma mark --- Class Methods for instance

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

@end
