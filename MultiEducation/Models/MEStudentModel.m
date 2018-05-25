//
//  MEStudentModel.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentModel.h"
#import <WHC_Model/NSObject+WHC_Model.h>

@interface MEStudentModel () <NSCoding>

@end

@implementation MEStudentModel

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        [self whc_Decode: coder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [self whc_Encode: coder];
}

@end
