//
//  MEIndexClassesScene.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@class MEIndexHeader;
@interface MEIndexClassesScene : MEBaseScene

/**
 是否显示或隐藏搜索栏
 */
@property (nonatomic, copy) void(^hideShowBarCallback)(BOOL);

/**
 类方法 init

 @param header 弱引用header
 */
+ (instancetype)classesSceneWithSubNavigationBar:(MEIndexHeader *)header;

/**
 切换当前类别
 */
- (void)changeNavigationClass4Page:(NSUInteger)page;

/**
 默认显示默认分类
 */
- (void)displayDefaultClass;

@end
