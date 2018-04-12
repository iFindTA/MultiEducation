//
//  MEIndexContentScene.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEIndexContentScene : MEBaseScene
/**
 隐藏显示搜索框 callback
 */
@property (nonatomic, copy) void(^callback)(BOOL hide);

/**
 init method

 @param cls 班级类型
 @param type 类型编号
 */
- (id)initWithFrame:(CGRect)frame class:(NSString *)cls typeCode:(NSUInteger)type;

/**
 将要显示此页面
 */
- (void)viewWillAppear;

/**
 页面将要消失
 */
- (void)viewWillDisappear;

/**
 由外部调用 触发切换类别后的首页-搜索框显示或隐藏问题
 */
- (void)triggered2fixedSearchBarHideOrShowAction;

@end
