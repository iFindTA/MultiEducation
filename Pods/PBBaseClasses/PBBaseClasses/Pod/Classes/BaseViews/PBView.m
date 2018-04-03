//
//  PBView.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBView.h"

@interface PBView ()

@property (nonatomic, strong) UILabel *placeholder;

@property (nonatomic, assign) BOOL wetherShowPlaceholder;

@end

@implementation PBView

- (void)showPlaceholder:(BOOL)show withInfo:(NSString *)holder {
    if ((!show && self.placeholder.hidden)||(show && self.placeholder.hidden)) {
        return;
    }
    
    if (show) {
        holder = holder.length==0?@"暂无内容":holder;
        self.placeholder.text = holder;
        //[self adjustPlaceholder];
    } else {
        [self.placeholder removeFromSuperview];
        _placeholder = nil;
    }
    self.wetherShowPlaceholder = show;
}

- (BOOL)isVisible {
    return self.window != nil;
}

- (void)adjustPlaceholder {
    
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_bot = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_let = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_rgh = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.placeholder addConstraints:@[constraint_top, constraint_bot, constraint_let, constraint_rgh]];
}

#pragma mark -- getter

- (UILabel *)placeholder {
    if (!_placeholder) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        _placeholder = label;
    }
    
    return _placeholder;
}

#pragma mark -- layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.wetherShowPlaceholder) {
        [self didTouchErrorPlaceholder];
    }
}

- (void)didTouchErrorPlaceholder {}

@end
