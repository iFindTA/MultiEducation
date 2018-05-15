//
//  MEIndexNavigationBar.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

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

@interface MEIndexNavigationBar : MEBaseScene

@property (nonatomic, copy) void(^indexNavigationBarItemCallback)(NSUInteger index);
@property (nonatomic, copy) void(^indexNavigationBarOtherCallback)(MEIndexNavigationType type);
@property (nonatomic, copy) void(^searchCallback)(BOOL first, NSString *_Nullable keyword);

+ (instancetype)indexNavigationBarWithTitles:(NSArray<NSDictionary *>*)titles;

/**
 导航菜单codes
 */
- (NSArray<NSString *>*)indexBarCodes;

- (void)scrollDidScroll2Page:(NSUInteger)page;

- (void)updatePlaceholder:(NSString * _Nullable)placeholder;

- (void)endSearchAction;

NS_ASSUME_NONNULL_END

@end
