//
//  MEClassMemberVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MeclassMember.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEClassMemberVM : MEVM

/**
 根据class ID 获取该班级目前最大的时间戳
 */
+ (int64_t)fetchMaxTimestamp4ClassID:(int64_t)classID;

/**
 根据class ID 获取班级成员
 */
+ (NSArray<MEClassMember*>*_Nullable)fetchClassMembers4ClassID:(int64_t)classID;

/**
 保存班级成员
 */
+ (BOOL)saveClassMembers:(NSArray<MEClassMember*>*)members;

@end

NS_ASSUME_NONNULL_END
