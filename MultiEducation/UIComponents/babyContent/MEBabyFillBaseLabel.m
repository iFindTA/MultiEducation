//
//  MEBabyFillBaseLabel.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyFillBaseLabel.h"

@implementation MEBabyFillBaseLabel
{
    UIViewController *_currCtl;
    NSString *_fillPlaceHolder;
    NSString *_backText;
    MEBaseButton *_labelBtn;
}

- (instancetype)initWithWidth:(CGFloat)width withText:(NSString *)text withFont:(CGFloat)font withTextColor:(UIColor *)textColor  withCtl:(UIViewController *)ctl{
    self = [self init];
    if (self) {
        _currCtl = ctl;
        self.contentStr = text;
        [self createBtnLabelWithWidth:width withText:text withFont:font withTextColor:textColor];
    }
    return self;
}

- (void)createBtnLabelWithWidth:(CGFloat)width withText:(NSString *)text withFont:(CGFloat)font withTextColor:(UIColor *)textColor {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, font);
    
    MEBaseButton *labelBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [labelBtn setTitle:text forState:UIControlStateNormal];
    [labelBtn setTitleColor:textColor forState:UIControlStateNormal];
    labelBtn.titleLabel.font = UIFontPingFangSC(font);
    [labelBtn addTarget:self action:@selector(labelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:labelBtn];
    _labelBtn = labelBtn;
    
    weakify(self);
    [labelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.edges.mas_equalTo(self);
    }];
}

- (void)labelTouch:(UIButton *)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入修改内容" preferredStyle:UIAlertControllerStyleAlert];
    weakify(self);
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        UITextField *textField = alertController.textFields.firstObject;
        self.contentStr = textField.text;
        [self returnResultAndReload:textField.text];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        strongify(self);
        textField.text = self.contentStr;
    }];

    [_currCtl presentViewController:alertController animated:true completion:nil];
}

//return modifier data
- (void)returnResultAndReload:(NSString *)text {
    [_labelBtn setTitle:text forState:UIControlStateNormal];
    if (self.textRutrn) {
        self.textRutrn(self.contentStr);
    }
}



@end
