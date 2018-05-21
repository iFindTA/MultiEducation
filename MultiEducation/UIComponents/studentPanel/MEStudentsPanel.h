//
//  MEStudentsPanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentListVM.h"

/**
 切换学生回调

 @param sid 切换到的学生ID
 @param pre_sid 切换之前的学生ID
 */
typedef void(^MEStudentPanelCallback)(int64_t sid, int64_t pre_sid);

typedef void(^MEStudentEditCallback)(BOOL done);

@interface MEStudentsPanel : MEBaseScene

/**
 touch callback
 */
@property (nonatomic, copy) MEStudentPanelCallback callback;

/**
 edit callback
 */
@property (nonatomic, copy) MEStudentEditCallback   editCallback;

@property (nonatomic, assign) int64_t classID;
@property (nonatomic, assign) int64_t gradeID;
@property (nonatomic, assign) int64_t semester;
@property (nonatomic, assign) int32_t month;

/**
 类型 2:学期评价 4:发展评价 6:趣事趣影
 */
@property (nonatomic, assign) int32_t type;

/**
 method for instance
 */
+ (instancetype)panelWithSuperView:(UIView *)view topMargin:(UIView *)margin;

/**
 load content and configure
 */
- (void)loadAndConfigure;

/**
 update student evaluate state
 */
- (void)updateStudent:(int64_t)sid status:(MEEvaluateState)state;

@end

/**
 student fixed height
 */
FOUNDATION_EXPORT CGFloat const ME_STUDENT_PANEL_HEIGHT;
