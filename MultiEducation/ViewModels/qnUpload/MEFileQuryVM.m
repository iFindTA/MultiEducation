//
//  MEFileQuryVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEFileQuryVM.h"

@interface MEFileQuryVM ()

@property (nonatomic, strong) MEPBQNFile *qnPb;

@end

@implementation MEFileQuryVM

+ (instancetype)vmWithPb:(MEPBQNFile *)qnPb {
    NSAssert(qnPb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPb: qnPb];
}

- (instancetype)initWithPb:(MEPBQNFile *)pb {
    self = [super init];
    if (self) {
        _qnPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return @"FSC_QN_FILE_GET";
}

@end
