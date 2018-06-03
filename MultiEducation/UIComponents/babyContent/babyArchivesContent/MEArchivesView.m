//
//  MEArchivesView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEArchivesView.h"
#import <IQKeyboardManager.h>

@interface MEArchivesView() <UITextFieldDelegate> {
    BOOL _isEditing;   // whether is editing status
    BOOL _whetherNeedGes;
}

/**
 Specific content e.g. the specific count for weight = 70
 */
@property (nonatomic, strong) MEBaseLabel *titleLab;


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
        
        [IQKeyboardManager sharedManager].enable = false;
        [IQKeyboardManager sharedManager].enableAutoToolbar = false;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapArchivesView)];
        [self addGestureRecognizer: tapGes];
    }
    return self;
}

- (void)didTapArchivesView {
    if (_whetherNeedGes) {
        if (!_isEditing) {
            self.titleLab.hidden = true;
            self.titleTextField.hidden = false;
            [self.titleTextField becomeFirstResponder];
        }
    } else {
        if (self.didTapArchivesViewCallback) {
            self.didTapArchivesViewCallback();
        }
    }
}

- (void)configArchives:(BOOL)whetherNeedGes {
    
    _whetherNeedGes = whetherNeedGes;
    
    self.titleLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
    self.titleLab.text = _title;
    self.titleLab.font = UIFontPingFangSC(17);
    self.titleLab.textColor = UIColorFromRGB(0x333333);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview: self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(adoptValue(2.f));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(adoptValue(25));
    }];
    
    if (_whetherNeedGes) {
        self.titleTextField = [[UITextField alloc] initWithFrame: CGRectZero];
//        self.titleTextField.placeholder = self.titleLab.text;
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: self.titleTextField.placeholder];
//        [attStr addAttribute: NSFontAttributeName value: self.titleLab.font range: NSMakeRange(0, self.titleTextField.placeholder.length)];
//        [attStr addAttribute: NSForegroundColorAttributeName value: self.tipLab.textColor range: NSMakeRange(0, self.titleTextField.placeholder.length)];
//        self.titleTextField.attributedPlaceholder = attStr;
        self.titleTextField.textColor = self.titleLab.textColor;
        self.titleTextField.font = self.titleLab.font;
        self.titleTextField.text = self.title;
        self.titleTextField.hidden = true;
        self.titleTextField.delegate = self;
        [self addSubview: self.titleTextField];
        [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.titleLab);
        }];
    }

    self.tipLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
    self.tipLab.text = _tip;
    self.tipLab.font = UIFontPingFangSC(12);
    self.tipLab.textColor = UIColorFromRGB(0x999999);
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview: self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(adoptValue(4.f));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(adoptValue(17.f));
    }];
    
    if (self.type == MEArchivesTypeTipCount) {
        NSString *symbol;
        if (_count > 0) { symbol = @"+"; }
        else { symbol = @"-"; }
        self.countLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
        self.countLab.text = [NSString stringWithFormat:@"%@%.1f", symbol, _count];
        self.countLab.font = UIFontPingFangSC(10);
        self.countLab.textColor = UIColorFromRGB(0xD46767);
        self.countLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview: self.countLab];
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_top);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(adoptValue(13));
        }];
        
        self.tipImageView = [[MEBaseImageView alloc] init];
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

- (void)updateCountLabWhileTitleTextChanged:(NSInteger)count {
    if (count > 0) {
        _tipImageView.image = [UIImage imageNamed: @"baby_archives_add_count"];
    } else {
        _tipImageView.image = [UIImage imageNamed: @"baby_archives_decrease_count"];
    }
}

- (void)changeTitle:(NSString *)titleText {
    self.titleLab.text = titleText;
    self.titleTextField.text = titleText;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isEditing = true;
    self.titleTextField.text = self.titleLab.text;
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _isEditing = false;
    self.titleLab.hidden = false;
    self.titleTextField.hidden = true;
}

#pragma mark - setter
- (void)setTitleTextColor:(UIColor *)titleTextColor {
    self.titleLab.textColor = titleTextColor;
    self.titleTextField.textColor = titleTextColor;
}

- (void)setTipTextColor:(UIColor *)tipTextColor {
    self.tipLab.textColor = tipTextColor;
}

@end
