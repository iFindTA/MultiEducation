//
//  MEIndexBgScroller.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEIndexNavigationBar.h"

@interface MEIndexBgScroller : MEBaseScene

/**
 类方法 init
 */
+ (instancetype)sceneWithSubBar:(MEIndexNavigationBar *)bar;

/**
 切换当前类别
 */
- (void)changeNavigationClass4Page:(NSUInteger)page;

/**
 默认显示默认分类
 */
- (void)displayDefaultClass;

@end
