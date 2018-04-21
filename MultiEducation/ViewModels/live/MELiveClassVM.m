//
//  MELiveClassVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveClassVM.h"

@implementation MELiveClassVM

#pragma mark --- @override methods

- (NSString *)cmdCode {
    return @"FSC_CLASS_LIVE_GET";
}

- (NSString *)cmdVersion {
    return @"2";
}

@end
