//
//  GuIndexPb+MEStore.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "GuIndexPb+MEStore.h"

@implementation GuIndexPb (MEStore)

+ (NSArray *)whc_IgnorePropertys {
    return @[@"hasStudentArchives"];
}

@end
