//
//  MEContentSubcategory.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEContentSubcategory : MEBaseScene

/**
 子分类回调
 */
@property (nonatomic, copy) void(^subClassesCallback)(NSUInteger tag);

/**
 类方法 子类化子分类面板
 */
+ (instancetype)subcategoryWithClasses:(NSArray *)cls;

/**
 由classes预估高度
 */
+ (NSUInteger)subcategoryClassPanelHeight4Classes:(NSArray *)cls;

@end
