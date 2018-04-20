//
//  MEStudentVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentVM.h"

@interface MEStudentVM ()

@property (nonatomic, strong) StudentPb *pb;

@end

@implementation MEStudentVM

+ (instancetype)vmWithPb:(StudentPb *)pb {
    return [[self alloc] initWithPb: pb];
}

- (instancetype)initWithPb:(StudentPb *)pb {
    self = [super init];
    if (self) {
        _pb = pb;
    } 
    return self;
}

+ (void)saveSelectBaby:(StudentPb *)student {
    
}

- (NSString *)cmdCode {
    return @"GU_SWITCH_CLASS";
}

@end
