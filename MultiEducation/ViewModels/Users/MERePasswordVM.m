//
//  MERePasswordVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MERePasswordVM.h"

@interface MERePasswordVM ()

@property (nonatomic, strong) MEPBUser *usr;

@end

@implementation MERePasswordVM

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

- (NSString *)cmdCode {
    return PASSWORD_PATCH;
}


@end
