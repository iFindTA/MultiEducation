//
//  MEIndexHeader.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexHeader.h"

static NSUInteger ME_INDEX_HEADER_FONT_MAX                     =   18;
static NSUInteger ME_INDEX_HEADER_FONT_MIN                     =   16;


@interface MEIndexHeader ()

@property (nonatomic, strong) UIFont *selectFont, *normalFont;
@property (nonatomic, strong) UIColor *selectColor, *normalColor;

/**
 类别按钮集合
 */
@property (nonatomic, strong) NSArray <MEBaseButton *>*classBtns;
@property (nonatomic, assign) NSUInteger currentSelectIndex;
@property (nonatomic, strong) NSArray <MEBaseLabel *>*classLabs;

@end

@implementation MEIndexHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectFont = UIFontSystemBold(ME_INDEX_HEADER_FONT_MAX);
    self.normalFont = UIFontSystem(ME_INDEX_HEADER_FONT_MIN);
    self.selectColor = UIColorFromRGB(0xFFFFFF);
    self.normalColor = [UIColor colorWithWhite:1.0 alpha:0.85];
    self.currentSelectIndex = 0;
    //*
    NSArray <NSString*>*titles = [self fetchNavigationClasses];
    self.classBtns = @[self.chosenBtn, self.xiaobanBtn, self.zhongbanBtn, self.dabanBtn];
    [self.classBtns enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = titles[idx];
        obj.titleLabel.text = title;
        obj.titleLabel.textAlignment = NSTextAlignmentCenter;
        [obj setTitle:title forState:UIControlStateNormal];
        [obj.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }];
    //*/
    
    //self.classLabs = @[self.label1, self.label2, self.label3, self.label4];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateFontStateExcept:(UIButton *)sender {
    [UIView animateWithDuration:ME_ANIMATION_DURATION delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.classBtns enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[obj titleLabel] setFont:obj == sender?self.selectFont:self.normalFont];
            [[obj titleLabel] setTextColor:obj == sender?self.selectColor:self.normalColor];
            if (obj == sender) {
                self.currentSelectIndex = idx;
            }
        }];
    } completion:nil];
    
}

- (IBAction)chosenTouchEvent:(MEBaseButton *)sender {
    [self updateFontStateExcept:sender];
    [self callbackDelegateWithTypePage:sender.tag];
}
- (IBAction)xiaobanTouchEvent:(MEBaseButton *)sender {
    [self updateFontStateExcept:sender];
    [self callbackDelegateWithTypePage:sender.tag];
}
- (IBAction)zhongbanTouchEvent:(MEBaseButton *)sender {
    [self updateFontStateExcept:sender];
    [self callbackDelegateWithTypePage:sender.tag];
}
- (IBAction)dabanTouchEvent:(MEBaseButton *)sender {
    [self updateFontStateExcept:sender];
    [self callbackDelegateWithTypePage:sender.tag];
}

- (IBAction)msgTouchEvent:(MEBaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchGardenNotice4indexHeader:)]) {
        [self.delegate didTouchGardenNotice4indexHeader:self];
    }
}
- (IBAction)historyTouchEvent:(MEBaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchVisitorHistory4indexHeader:)]) {
        [self.delegate didTouchVisitorHistory4indexHeader:self];
    }
}

- (void)callbackDelegateWithTypePage:(NSUInteger)page {
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexHeader:didTouchNavigationPage:)]) {
        [self.delegate indexHeader:self didTouchNavigationPage:page];
    }
}

#pragma mark --- methods
- (NSArray<NSString *>*)fetchNavigationClasses {
    return @[@"精选", @"小班", @"中班", @"大班"];
}

- (MEBaseButton *)fetchBtn4Title:(NSString *)title {
    __block MEBaseButton *btn;
    [self.classBtns enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.titleLabel.text isEqualToString:title]) {
            btn = obj;
            *stop = true;
        }
    }];
    return btn;
}
#pragma mark --- scrollView 联动
- (void)scrollDidScrollProgress:(CGFloat)progress {
    NSUInteger totalCounts = self.classBtns.count;
    if (progress <= 0 || progress >= totalCounts-1) {
        //NSLog(@"边界 不做处理！");
        return;
    }
    //取到目标值
    NSUInteger leftIndex = floor(progress);
    NSUInteger rightIndex = ceil(progress);
    //NSLog(@"scroll progress:%f------left idx:%zd=====right idx:%zd", progress, leftIndex, rightIndex);
    NSAssert(leftIndex < totalCounts && rightIndex < totalCounts, @"object beyond boundary!");
    //计算过度
    if (leftIndex == rightIndex) {
        leftIndex -= 1;
    }
    CGFloat absoluteProgress = progress - leftIndex;
    NSUInteger absoluteFontValue = ME_INDEX_HEADER_FONT_MAX - ME_INDEX_HEADER_FONT_MIN;
    //变化量
    CGFloat changeFontValue = absoluteProgress * absoluteFontValue;
    CGFloat leftFontSize = ME_INDEX_HEADER_FONT_MAX - changeFontValue;
    CGFloat rightFontSize = ME_INDEX_HEADER_FONT_MIN + changeFontValue;
    UIFont *leftFont = UIFontPingFangSC(leftFontSize);
    UIFont *rigntFont = UIFontPingFangSC(rightFontSize);
    [UIView animateWithDuration:0.001 animations:^{
        self.classBtns[leftIndex].titleLabel.font = leftFont;
        self.classBtns[rightIndex].titleLabel.font = rigntFont;
    }];
}

- (void)scrollDidScroll2Page:(NSUInteger)page {
    NSUInteger totalCounts = self.classBtns.count;
    if (page >= totalCounts) {
        //NSLog(@"边界 不做处理！");
        return;
    }
    if (self.currentSelectIndex == page) {
        return;
    }
    self.currentSelectIndex = page;
    [UIView animateWithDuration:ME_ANIMATION_DURATION delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.classBtns enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[obj titleLabel] setFont:idx == page?self.selectFont:self.normalFont];
            [[obj titleLabel] setTextColor:idx == page?self.selectColor:self.normalColor];
        }];
    } completion:nil];
}

@end
