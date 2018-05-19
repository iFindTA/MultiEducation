//
//  MEStudentListVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Mestudent.pbobjc.h"

typedef NS_ENUM(NSUInteger, MEEvaluateState) {
    MEEvaluateStateNone                             =   0,//未填写
    MEEvaluateStateDone                             =   1,//已完成
    MEEvaluateStateStash                            =   2,//已暂存
    MEEvaluateStateChoosing                         =   3,//当前选中
};

@interface MEStudentListVM : MEVM

@end
