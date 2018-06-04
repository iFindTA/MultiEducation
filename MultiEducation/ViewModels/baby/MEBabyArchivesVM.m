//
//  MEBabyArchivesVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/4.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyArchivesVM.h"
#import "MebabyIndex.pbobjc.h"

@interface MEBabyArchivesVM ()

@property (nonatomic, strong) GuStudentArchivesPb *pb;
@property (nonatomic, strong) NSString *cmd;


@end

@implementation MEBabyArchivesVM

+ (instancetype)vmWithPb:(GuStudentArchivesPb *)pb cmdCode:(NSString *)cmdCode {
    return [[self alloc] initWithPb: pb cmd: cmdCode];
}

- (instancetype)initWithPb:(GuStudentArchivesPb *)pb cmd:(NSString *)cmd {
    self = [super init];
    if (self) {
        self.cmd = cmd;
        _pb = pb;
    }
    return self; 
}

- (NSString *)cmdCode {
    return self.cmd;
}

@end
