//
//  MESubNavigator.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESubNavigator.h"

CGFloat const ME_SUBNAVGATOR_HEIGHT = 44;

@interface MESubNavigator ()

/**
 标题
 */
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout

@property (nonatomic, strong) MEBaseScene *flag;

@end

@implementation MESubNavigator

+ (instancetype)navigatorWithTitles:(NSArray<NSString *> *)titles defaultIndex:(NSUInteger)index {
    return [[MESubNavigator alloc] initWithFrame:CGRectZero titles:titles defaultSelectIndex:index];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles defaultSelectIndex:(NSUInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
