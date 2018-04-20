//
//  MEBabyGrowthVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentVM.h"

@interface MEStudentVM ()

@property (nonatomic, strong) MEStudentVM *pb;


@end

@implementation MEStudentVM

+ (instancetype)vmWithPb:(MEStudentVM *)pb {
    return [[self alloc] initWithPb: pb];
}

- (instancetype)initWithPb:(MEStudentVM *)pb {
    self = [super init];
    if (self) {
        _pb = pb;
    }
    return self;
}




@end
