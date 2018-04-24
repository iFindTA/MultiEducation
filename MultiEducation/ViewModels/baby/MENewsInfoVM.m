//
//  MENewsInfoVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENewsInfoVM.h"

@interface MENewsInfoVM ()

@property (nonatomic, strong) OsrInformationPb *osrPb;

@end

@implementation MENewsInfoVM

+ (instancetype)vmWithPb:(OsrInformationPb *)osrPb {
    return [[self alloc] initWithPb: osrPb];
}

- (instancetype)initWithPb:(OsrInformationPb *)pb {
    self = [super init];
    if (self) {
        _osrPb = pb;
    }
    return self;
}


- (NSString *)cmdCode {
    return @"OSR_INFORMATION_LIST";
}

@end
