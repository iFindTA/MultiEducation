//
//  MEIndexSearchMaskScene.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEIndexSearchMaskScene : MEBaseScene

/**
 关键字回调
 */
@property (nonatomic, copy) void(^callback)(NSString *key);

/**
 用户搜索了某个关键字 则更新历史搜索
 */
- (void)userDidTouchKeyword:(NSString *)key;

@end
