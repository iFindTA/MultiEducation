//
//  MEStudentsPanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentListVM.h"

typedef void(^MEStudentPanelCallback)(int64_t sid);

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

/**
 method for instance
 */
+ (instancetype)panelWithClassID:(int64_t)clsID superView:(UIView *)view topMargin:(UIView *)margin;

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
