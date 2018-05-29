//
//  MESubNavigator.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef void(^MESubNavigatorCallback)(NSUInteger index, NSUInteger preIndex);

@interface MESubNavigator : MEBaseScene

/**
 callback
 */
@property (nonatomic, copy) MESubNavigatorCallback callback;

/**
 default instance
 */
+ (instancetype)navigatorWithTitles:(NSArray<NSString*>*)titles defaultIndex:(NSUInteger)index;

/**
 triggered by scrollview
 */
- (void)willSelectIndex:(NSUInteger)index;

@end
/**
 sub navigation bar height
 */
FOUNDATION_EXPORT CGFloat const ME_SUBNAVGATOR_HEIGHT;
