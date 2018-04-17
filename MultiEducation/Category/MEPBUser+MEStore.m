//
//  MEPBUser+MEStore.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPBUser+MEStore.h"

@implementation MEPBUser (MEStore)

+ (NSString *)whc_SqliteMainkey {
    return @"id_p";
}

+ (NSArray *)whc_IgnorePropertys {
    return @[@"hasParentsPb",
             @"teacherPb",
             @"hasTeacherPb",
             @"schoolPb",
             @"hasSchoolPb",
             @"funcCtrlPbArray",
             @"funcCtrlPbArray_Count",
             @"hasInitPwd",
             @"groupStatus",
             @"systemConfigPb",
             @"hasSystemConfigPb",
             @"diskCap",
             @"deanPb",
             @"hasDeanPb",
             @"isTourist",
             @"isUserCharge",
             @"code"];
}

@end
