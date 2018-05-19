//
//  MESubNavigator.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESubNavigator.h"

CGFloat const ME_SUBNAVGATOR_HEIGHT = 44;

NSUInteger const ME_SUBNAVIGATOR_NUMPERLIME = 5;
CGFloat const ME_SUBNAVIGATOR_ITEM_DISTANCE = 10;
CGFloat const ME_SUBNAVIGATOR_FLAG_SCALE = 0.8;
NSUInteger const ME_SUBNAVIGATOR_TAG_START = 100;

@interface MESubNavigator ()

/**
 标题
 */
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

@property (nonatomic, strong) MEBaseScene *flag;
@property (nonatomic, strong) NSMutableArray <MEBaseButton*>*items;
@property (nonatomic, strong) UIColor *selectColor, *normalColor;

@end

@implementation MESubNavigator

+ (instancetype)navigatorWithTitles:(NSArray<NSString *> *)titles defaultIndex:(NSUInteger)index {
    return [[MESubNavigator alloc] initWithFrame:CGRectZero titles:titles defaultSelectIndex:index];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles defaultSelectIndex:(NSUInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = [NSArray arrayWithArray:titles];
        self.currentIndex = index;
        self.selectColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        self.normalColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        
        [self addSubview:self.scroller];
        [self.scroller addSubview:self.layout];
        [self.scroller makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.layout makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scroller);
            make.height.equalTo(self.scroller);
        }];
        [self __initSubNavigationBarSubviews];
    }
    return self;
}

- (void)__initSubNavigationBarSubviews {
    [self.items removeAllObjects];
    CGFloat boundary = ME_LAYOUT_BOUNDARY;
    CGFloat itemDistance = ME_SUBNAVIGATOR_ITEM_DISTANCE;
    CGFloat itemWidth = [self fetchItemWidth];
    UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_TITLE+1);
    MEBaseButton *lastItem = nil;
    int i = 0;
    for (NSString *t in self.titles) {
        UIColor *fontColor = self.currentIndex==i ? self.selectColor : self.normalColor;
        NSLog(@"%@-----%d", fontColor, i);
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ME_SUBNAVIGATOR_TAG_START + i;
        btn.titleLabel.font = font;
        [btn setTitle:t forState:UIControlStateNormal];
        [btn setTitleColor:fontColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(subNavigatorItemTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.layout addSubview:btn];
        [self.items addObject:btn];
        //layout
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.layout);
            make.left.equalTo((lastItem == nil? self.layout:lastItem.mas_right)).offset((lastItem==nil? boundary:itemDistance));
            make.width.equalTo(itemWidth);
        }];
        //flag
        lastItem = btn;
        i++;
    }
    //flag
    [self.layout addSubview:self.flag];
    MEBaseButton *btn = [self fetchCurrentItem];
    [self.flag makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.layout);
        make.centerX.equalTo(btn.mas_centerX);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT*2);
        make.width.equalTo(btn.mas_width).multipliedBy(ME_SUBNAVIGATOR_FLAG_SCALE);
    }];
    
    //right margin
    [self.layout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastItem.mas_right).offset(boundary);
    }];
}

#pragma mark --- lazy loading

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scroller.bounces = true;
        _scroller.pagingEnabled = false;
        _scroller.showsVerticalScrollIndicator = false;
        _scroller.showsHorizontalScrollIndicator = false;
        _scroller.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scroller;
}

- (MEBaseScene *)layout {
    if (!_layout) {
        _layout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _layout;
}

- (NSMutableArray<MEBaseButton*>*)items {
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:0];
    }
    return _items;
}

- (MEBaseScene *)flag {
    if (!_flag) {
        _flag = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _flag.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    }
    return _flag;
}

- (CGFloat)fetchItemWidth {
    NSUInteger counts = self.titles.count;
    if (counts == 0) {
        return MESCREEN_WIDTH;
    }
    return ceil((MESCREEN_WIDTH-ME_LAYOUT_BOUNDARY*2-(counts-1)*ME_SUBNAVIGATOR_ITEM_DISTANCE)/counts);
}

- (MEBaseButton *)fetchCurrentItem {
    if (self.currentIndex >= self.items.count) {
        return nil;
    }
    return self.items[self.currentIndex];
}

#pragma mark --- user interface actions

- (void)subNavigatorItemTouchEvent:(MEBaseButton *)btn {
    NSUInteger __tag = btn.tag - ME_SUBNAVIGATOR_TAG_START;
    if (__tag == self.currentIndex) {
        return;
    }
    NSUInteger preIndex = self.currentIndex;
    self.currentIndex = __tag;
    if (self.callback) {
        self.callback(__tag, preIndex);
    }
    [self updateCurrentFlagPosition];
}

- (void)willSelectIndex:(NSUInteger)index {
    if (index == self.currentIndex) {
        return;
    }
    self.currentIndex = index;
    [self updateCurrentFlagPosition];
}

- (void)updateCurrentFlagPosition {
    MEBaseButton *btn = [self fetchCurrentItem];
    [self.flag mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.layout);
        make.centerX.equalTo(btn.mas_centerX);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT*2);
        make.width.equalTo(btn.mas_width).multipliedBy(ME_SUBNAVIGATOR_FLAG_SCALE);
    }];
    //更改颜色
    [self.items enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *fontColor = (idx == self.currentIndex)? self.selectColor : self.normalColor;
        [obj setTitleColor:fontColor forState:UIControlStateNormal];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
