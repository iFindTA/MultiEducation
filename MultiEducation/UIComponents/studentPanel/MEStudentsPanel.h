//
//  MEStudentsPanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentListVM.h"

@interface MEStudentsPanel : MEBaseScene

/**
 method for instance
 */
+ (instancetype)panelWithClassID:(int64_t)clsID superView:(UIView *)view topMargin:(UIView *)margin;

/**
 load content and configure
 */
- (void)configurePanel;

@end
