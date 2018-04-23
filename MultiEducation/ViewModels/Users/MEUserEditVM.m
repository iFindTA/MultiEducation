//
//  MEUserEditVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserEditVM.h"

@interface MEUserEditVM ()

@property (nonatomic, strong) FscUserPb *usr;

@end

@implementation MEUserEditVM

+ (instancetype)vmWithModel:(FscUserPb *)usr {
    NSAssert(usr != nil, @" could not initialized by nil!");
    return [[self alloc] initWithUsr:usr];
}

- (id)initWithUsr:(FscUserPb *)usr {
    self = [super init];
    if (self) {
        _usr = usr;
    }
    return self;
}

- (NSString *)cmdCode {
    return PERSONAL_INFO_PATCH;
}

@end
