//
//  MESemesterEvaPanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/29.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MESEInfoVM.h"
#import "MEStudentInfoVM.h"
#import "MEStudentListVM.h"

@interface MESemesterEvaPanel : MEBaseScene

/**
 callback submit
 */
@property (nonatomic, copy) MEEvaluatePanelCallback callback;

/**
 切换学生去评估
 */
- (void)exchangedStudent2Evaluate:(SemesterEvaluate *)semester;

/**
 instance method
 */
- (id)initWithFrame:(CGRect)frame father:(UIView *)view;

@end
