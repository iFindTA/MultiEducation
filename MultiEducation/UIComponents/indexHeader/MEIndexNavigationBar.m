//
//  MEIndexNavigationBar.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexNavigationBar.h"

static NSUInteger ME_INDEX_HEADER_FONT_MAX                     =   18;
static NSUInteger ME_INDEX_HEADER_FONT_MIN                     =   16;

@interface MEIndexNavigationBar ()

@property (nonatomic, copy) NSArray <NSString*>*barTitles;

@property (nonatomic, strong) UIFont *selectFont, *normalFont;
@property (nonatomic, strong) UIColor *selectColor, *normalColor;
@property (nonatomic, strong) NSMutableArray <MEBaseButton*>*barItems;
@property (nonatomic, assign) NSUInteger currentSelectIndex;

@property (nonatomic, strong) MEBaseButton *noticeBtn;
@property (nonatomic, strong) MEBaseButton *historyBtn;

@end

@implementation MEIndexNavigationBar

+ (instancetype)indexNavigationBarWithTitles:(NSArray<NSString *> *)titles {
    MEIndexNavigationBar *bar = [[MEIndexNavigationBar alloc] initWithFrame:CGRectZero titles:titles];
    return bar;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectFont = UIFontPingFangSCBold(ME_INDEX_HEADER_FONT_MAX);
        self.normalFont = UIFontPingFangSCMedium(ME_INDEX_HEADER_FONT_MIN);
        self.selectColor = UIColorFromRGB(0xFFFFFF);
        self.normalColor = [UIColor colorWithWhite:1.0 alpha:0.85];
        self.currentSelectIndex = 0;
        self.barTitles = [NSArray arrayWithArray:titles];
        self.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        [self __initIndexNavigationBarSubviews];
    }
    return self;
}

- (void)__initIndexNavigationBarSubviews {
    //prepare
    [self.barTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        UIFont *font = (idx == self.currentSelectIndex)?self.selectFont:self.normalFont;
        UIColor *textColor = (idx == self.currentSelectIndex)?self.selectColor:self.normalColor;
        btn.titleLabel.font = font;
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(indexNavigationBarTitleItemTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.barItems addObject:btn];
    }];
    //历史
    UIImage *icon = [UIImage imageNamed:@"index_header_history"];
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(indexNavigationBarHistoryTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];self.historyBtn = btn;
    icon = [UIImage imageNamed:@"index_header_msg"];
    btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(indexNavigationBarNoticeTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];self.noticeBtn = btn;
}

- (NSMutableArray<MEBaseButton*>*)barItems {
    if (!_barItems) {
        _barItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _barItems;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger itemWidth = ME_LAYOUT_SUBBAR_HEIGHT;
    NSUInteger itemHeight = ME_HEIGHT_TABBAR * 0.5;
    [self.barItems enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ME_LAYOUT_MARGIN * 2 + (itemWidth+ME_LAYOUT_MARGIN)*idx);
            make.bottom.equalTo(self).offset(-ME_LAYOUT_MARGIN * 2);
            make.width.equalTo(itemWidth);
            make.height.equalTo(itemHeight);
        }];
    }];
    
    [self.historyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
        make.bottom.equalTo(self).offset(-ME_LAYOUT_MARGIN);
        make.width.height.equalTo(30);
    }];
    [self.noticeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.historyBtn.mas_left).offset(-ME_LAYOUT_MARGIN*2);
        make.bottom.equalTo(self).offset(-ME_LAYOUT_MARGIN);
        make.width.height.equalTo(30);
    }];
}

#pragma mark --- update state

- (void)updateFontStateExcept:(MEBaseButton *)sender {
    [UIView animateWithDuration:ME_ANIMATION_DURATION delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.barItems enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[obj titleLabel] setFont:((obj.tag == sender.tag)?self.selectFont:self.normalFont)];
            [[obj titleLabel] setTextColor:((obj.tag == sender.tag)?self.selectColor:self.normalColor)];
            [obj setTitleColor:((obj.tag == sender.tag)?self.selectColor:self.normalColor) forState:UIControlStateNormal];
            if (obj == sender) {
                self.currentSelectIndex = idx;
            }
        }];
    } completion:nil];
}

- (void)scrollDidScroll2Page:(NSUInteger)page {
    NSUInteger totalCounts = self.barItems.count;
    if (page >= totalCounts) {
        //NSLog(@"边界 不做处理！");
        return;
    }
    if (self.currentSelectIndex == page) {
        return;
    }
    self.currentSelectIndex = page;
    for (MEBaseButton *btn in self.barItems) {
        [[btn titleLabel] setFont:((btn.tag == page)?self.selectFont:self.normalFont)];
        [[btn titleLabel] setTextColor:((btn.tag == page)?self.selectColor:self.normalColor)];
        [btn setTitleColor:((btn.tag == page)?self.selectColor:self.normalColor) forState:UIControlStateNormal];
    }
}

#pragma mark --- Touch Event

- (void)indexNavigationBarTitleItemTouchEvent:(MEBaseButton *)btn {
    [self updateFontStateExcept:btn];
    if (self.indexNavigationBarItemCallback) {
        self.indexNavigationBarItemCallback(btn.tag);
    }
}

- (void)indexNavigationBarHistoryTouchEvent {
    if (self.indexNavigationBarOtherCallback) {
        self.indexNavigationBarOtherCallback(MEIndexNavigationTypeHistory);
    }
}

- (void)indexNavigationBarNoticeTouchEvent {
    if (self.indexNavigationBarOtherCallback) {
        self.indexNavigationBarOtherCallback(MEIndexNavigationTypeNotice);
    }
}

#pragma mark --- getter

- (NSArray *)indexNavigationBarTitles {
    return [NSArray arrayWithArray:self.barTitles];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
