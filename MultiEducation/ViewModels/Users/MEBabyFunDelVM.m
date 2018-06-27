//
//  MEBabyFunDelVM.m
//  MultiEducation
//
//  Created by cxz on 2018/6/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyFunDelVM.h"
#import "MestuFun.pbobjc.h"

@interface MEBabyFunDelVM ()

@property (nonatomic, strong) GuFunPhotoPb *funPb;

@end

@implementation MEBabyFunDelVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return @"GU_FUN_PHOTO_DEL";
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithPB:(GuFunPhotoPb *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(GuFunPhotoPb *)pb {
    self = [super init];
    if (self) {
        _funPb = pb;
    }
    return self;
}

@end
