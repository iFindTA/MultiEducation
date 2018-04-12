//
//  MEIndexHeader.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

/**
 类型定义
 */
typedef NS_ENUM(NSUInteger, MEIndexNavigationType) {
    MEIndexNavigationTypeChosen                                 =   1   <<  0,//精选
    MEIndexNavigationTypeXiaoban                                =   1   <<  1,//小班
    MEIndexNavigationTypeZhongban                               =   1   <<  2,//中班
    MEIndexNavigationTypeDaban                                  =   1   <<  3,//大班
    MEIndexNavigationTypeNotice                                 =   1   <<  4,//通知
    MEIndexNavigationTypeHistory                                =   1   <<  5,//历史
};

@protocol MEIndexHeaderDelegate;
@interface MEIndexHeader : MEBaseScene

@property (nonatomic, weak) IBOutlet MEBaseButton *chosenBtn;
@property (nonatomic, weak) IBOutlet MEBaseButton *xiaobanBtn;
@property (nonatomic, weak) IBOutlet MEBaseButton *zhongbanBtn;
@property (nonatomic, weak) IBOutlet MEBaseButton *dabanBtn;

@property (nonatomic, weak) IBOutlet MEBaseButton *msgBtn;
@property (nonatomic, weak) IBOutlet MEBaseButton *historyBtn;

@property (nonatomic, weak) id <MEIndexHeaderDelegate> delegate;

/**
 获取导航的类别
 */
- (NSArray<NSString *>*)fetchNavigationClasses;

/**
 滑动scrollview progress
 */
- (void)scrollDidScrollProgress:(CGFloat)progress;

/**
  滑动scrollview page
 */
- (void)scrollDidScroll2Page:(NSUInteger)page;

@end

@protocol MEIndexHeaderDelegate <NSObject>
@optional

/**
 点击导航分类
 */
- (void)indexHeader:(MEIndexHeader *)header didTouchNavigationPage:(NSUInteger)page;

/**
 点击幼儿园通知
 */
- (void)didTouchGardenNotice4indexHeader:(MEIndexHeader *)header;

/**
 点击观看记录
 */
- (void)didTouchVisitorHistory4indexHeader:(MEIndexHeader *)header;

@end;
