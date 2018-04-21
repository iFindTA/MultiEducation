//
//  MEStudentVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentVM.h"
#import "AppDelegate.h"

@interface MEStudentVM ()

@property (nonatomic, strong) StudentPb *pb;
@property (nonatomic, strong) NSString *cmd;

@end

@implementation MEStudentVM

+ (instancetype)vmWithPb:(StudentPb *)pb cmdCode:(NSString *)cmdCode{
    return [[self alloc] initWithPb: pb cmdCode: cmdCode];
}

- (instancetype)initWithPb:(StudentPb *)pb cmdCode:(NSString *)cmdCode {
    self = [super init];
    if (self) {
        _pb = pb;
        self.cmd = cmdCode;
    } 
    return self;
}

- (NSString *)cmdCode {
    return self.cmd;
}

@end
