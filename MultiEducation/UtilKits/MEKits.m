//
//  MEKits.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import <sys/stat.h>

@implementation MEKits

+ (CGFloat)fileSizeWithPath:(NSString *)path {
    NSAssert(path.length != 0, @"empty file path");
    const char *filename = path.UTF8String;
    struct stat st;
    memset(&st, 0, sizeof(st));
    stat(filename, &st);
    return st.st_size;
}

@end
