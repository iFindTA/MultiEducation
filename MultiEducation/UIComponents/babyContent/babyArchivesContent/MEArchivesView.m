//
//  MEArchivesView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEArchivesView.h"
#import <SVProgressHUD.h>

@interface MEArchivesView() <UITextFieldDelegate> {
    BOOL _whetherNeedGes;
    BOOL _isHavePoint;  //是否有了小数点
}

/**
 edit title
 */
@property (nonatomic, strong) UITextField *titleTextField;

/**
 tip, e.g. name height weight
 */
@property (nonatomic, strong) MEBaseLabel *tipLab;

/**
 the change count for original
 */
@property (nonatomic, strong) MEBaseLabel *countLab;
@property (nonatomic, strong) MEBaseImageView *tipImageView;

@end

@implementation MEArchivesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapArchivesView)];
        [self addGestureRecognizer: tapGes];
    }
    return self;
}

- (void)didTapArchivesView {
    if (self.currentUser.userType == MEPBUserRole_Gardener) {
        return;
    }
    if (_whetherNeedGes) {
        [self.titleTextField becomeFirstResponder];
    } else {
        if (self.didTapArchivesViewCallback) {
            self.didTapArchivesViewCallback();
        }
    }
}

- (void)configArchives:(BOOL)whetherNeedGes {
    _whetherNeedGes = whetherNeedGes;
    if (!_titleTextColor) {
        _titleTextColor = UIColorFromRGB(0x333333);
    }
    
    if (!_tipTextColor) {
        _tipTextColor = UIColorFromRGB(0x999999);
    }
    self.titleTextField = [[UITextField alloc] initWithFrame: CGRectZero];
//        self.titleTextField.placeholder = self.titleLab.text;
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: self.titleTextField.placeholder];
//        [attStr addAttribute: NSFontAttributeName value: self.titleLab.font range: NSMakeRange(0, self.titleTextField.placeholder.length)];
//        [attStr addAttribute: NSForegroundColorAttributeName value: self.tipLab.textColor range: NSMakeRange(0, self.titleTextField.placeholder.length)];
//        self.titleTextField.attributedPlaceholder = attStr;
    self.titleTextField.textColor = _titleTextColor;
    if (_isOnlyNumber) {
        self.titleTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    self.titleTextField.font = UIFontPingFangSC(17);
    self.titleTextField.text = self.title;
    self.titleTextField.textAlignment = NSTextAlignmentCenter;
    self.titleTextField.delegate = self;
    [self addSubview: self.titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(adoptValue(2.f));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(adoptValue(25));
        
    }];

    self.tipLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
    self.tipLab.backgroundColor = [UIColor clearColor];
    self.tipLab.text = _tip;
    self.tipLab.font = UIFontPingFangSC(12);
    self.tipLab.textColor = _tipTextColor;
    self.tipLab.userInteractionEnabled = true;
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview: self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_offset(adoptValue(4.f));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(adoptValue(17.f));
    }];
    
    if (self.type == MEArchivesTypeTipCount) {
        NSString *symbol = @"";
        if (_count > 0) { symbol = @"+"; }
        self.countLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
        self.countLab.backgroundColor = [UIColor clearColor];
        self.countLab.text = [NSString stringWithFormat:@"%@%.1f", symbol, _count];
        self.countLab.userInteractionEnabled = true;
        self.countLab.font = UIFontPingFangSC(10);
        self.countLab.textColor = UIColorFromRGB(0xD46767);
        self.countLab.textAlignment = NSTextAlignmentLeft;
        [self changeCount: _count];
        [self addSubview: self.countLab];
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleTextField.mas_top);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(adoptValue(13));
        }];
        
        self.tipImageView = [[MEBaseImageView alloc] init];
        self.tipImageView.backgroundColor = [UIColor clearColor];
        self.tipImageView.userInteractionEnabled = true;
        [self updateCountLabWhileTitleTextChanged: _count];
        [self addSubview: self.tipImageView];
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.countLab.mas_bottom).mas_offset(3.f);
            make.width.mas_equalTo(6.f);
            make.height.mas_equalTo(7.f);
            make.centerX.mas_equalTo(self.countLab);
        }];
    }
}

- (void)updateCountLabWhileTitleTextChanged:(double)count {
    if (count > 0) {
        _tipImageView.image = [UIImage imageNamed: @"baby_archives_add_count"];
        _tipImageView.hidden = false;
    } else if(count < 0) {
        _tipImageView.image = [UIImage imageNamed: @"baby_archives_decrease_count"];
        _tipImageView.hidden = false;
    } else {
        _tipImageView.hidden = true;
    }
}

- (void)setPlaceHolder:(NSString *)placeholder {
    self.titleTextField.placeholder = placeholder;
}

- (void)setPlaceHolderTextColor:(UIColor *)color {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: self.titleTextField.placeholder attributes: @{NSForegroundColorAttributeName: color}];
    self.titleTextField.attributedPlaceholder = attStr;
}

- (void)changeTitle:(NSString *)titleText {
    self.titleTextField.text = titleText;
    self.title = titleText;
}

- (void)changeTip:(NSString *)tipText {
    self.tipLab.text = tipText;
    self.tip = tipText;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isOnlyNumber) {
        if ([textField.text containsString: @"."]) {
            _isHavePoint = true;
        } else {
            _isHavePoint = false;
        }
    }
    if (!_whetherNeedGes) {
        [self didTapArchivesView];
        return false;
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.title = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!_isOnlyNumber) {
        self.title = textField.text;
        return true;
    }
    
    if (! [self whetherInputBiggerThanInputMaxNumber: [NSString stringWithFormat: @"%@%@", textField.text, string]]) {
        return false;
    }
   
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHavePoint = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [MEKits makeTopToast: @"首位不能为."];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //当第一位是0，第二位不能是0
            if([textField.text length] == 1){
                if([textField.text isEqualToString: @"0"] && single == '0') {
                    [MEKits makeTopToast: @"请输入正确的数字格式"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHavePoint) {
                    //text中还没有小数点
                    _isHavePoint = YES;
                    self.title = textField.text;
                    return YES;
                } else {
                    [MEKits makeTopToast: @"小数点已存在"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHavePoint) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 1) {
                        self.title = textField.text;
                        return YES;
                    } else {
                        [MEKits makeTopToast: @"小数点后最多可输入一位"];
                        return NO;
                    }
                } else {
                    self.title = textField.text;
                    return YES;
                }
            }
        } else {//输入的数据格式不正确
            [MEKits makeTopToast: @"文字格式错误！"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else {
        self.title = textField.text;
        return YES;
    }
}

- (BOOL)whetherInputBiggerThanInputMaxNumber:(NSString *)text {
    if (_isOnlyNumber) {
        if ([text floatValue] > _maxNum) {
            _titleTextField.text = [NSString stringWithFormat: @"%.1f", _maxNum];
            _isHavePoint = true;
            NSString *tipText = [_tipLab.text componentsSeparatedByString: @"("].firstObject;
            [MEKits makeTopToast: [NSString stringWithFormat: @"请输入正确的宝宝%@", tipText]];
            return false;
        }
        return true;
    }
    return true;
}

#pragma mark - setter
- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    self.titleTextField.textColor = titleTextColor;
}

- (void)setTipTextColor:(UIColor *)tipTextColor {
    _tipTextColor = tipTextColor;
    self.tipLab.textColor = tipTextColor;
}

- (void)changeCount:(double)count {
    _count = count;
    if (count == 0) {
        self.countLab.text = @"";
    } else {
        self.countLab.text = [NSString stringWithFormat: @"%.1f", count];
    }
    [self updateCountLabWhileTitleTextChanged: count];
}

- (void)setOriginText:(NSString *)originText {
    _originText = originText;
    self.titleTextField.text = originText;
    self.title = originText;
}

@end
