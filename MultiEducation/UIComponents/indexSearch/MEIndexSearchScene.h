//
//  MEIndexSearchScene.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@class MEIndexSearchBar;
@interface MEIndexSearchScene : MEBaseScene

/**
 弱引用搜索菜单
 */
@property (nonatomic, weak) MEIndexSearchBar *searchBar;

/**
 重置搜索状态 清空搜索结果、覆盖mask
 */
- (void)resetSearchState;

@end
