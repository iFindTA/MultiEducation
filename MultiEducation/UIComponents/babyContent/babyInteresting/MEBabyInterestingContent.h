//
//  MEBabyInterestingContent.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MestuFun.pbobjc.h"

@interface MEBabyInterestingContent : MEBaseScene

/**
 当前选中位置
 */
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
/**
 设置数据源
 */
@property (nonatomic, strong) NSArray <GuFunPhotoPb *> *items;
/**
 是否分页，默认为true
 */
@property (nonatomic, assign) BOOL pagingEnabled;

@property (nonatomic, copy) void(^gotoPhotoBrowserHandler) (GuFunPhotoPb *pb);
@property (nonatomic, copy) void(^didDeleteBabyFunSuccessCallback) (void);

/**
 手动滚动到某个卡片位置
 */
- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;

@end
