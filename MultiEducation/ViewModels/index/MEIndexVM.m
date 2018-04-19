//
//  MEIndexVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexVM.h"

@implementation MEIndexVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return @"OSR_INDEX";
}

- (NSString *)operationCode {
    return @"REQ_FSC_INDEX_UPDATE";
}

@end
