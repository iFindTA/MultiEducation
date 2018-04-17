//
//  MEQNUploadVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEQNUploadVM.h"
#import "Meqnfile.pbobjc.h"

@interface MEQNUploadVM ()

@property (nonatomic, strong) MEPBQNFile *qnPb;

@end

@implementation MEQNUploadVM

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
    return FSC_QN_FILE_GET;
}

@end
