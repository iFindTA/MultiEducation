//
//  MEPBUser+MEStore.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPBUser+MEStore.h"

@implementation MEPBUser (MEStore)

//+ (NSString *)whc_SqliteMainkey {
//    return @"uid";
//}

+ (NSArray *)whc_IgnorePropertys {
    return @[@"hasParentsPb",
             @"hasTeacherPb",
             @"hasSchoolPb",
             @"funcCtrlPbArray",
             @"funcCtrlPbArray_Count",
             @"hasInitPwd",
             @"groupStatus",
             @"systemConfigPb",
             @"hasSystemConfigPb",
             @"diskCap",
             @"hasDeanPb",
             @"isUserCharge",
             @"code"];
}

@end
