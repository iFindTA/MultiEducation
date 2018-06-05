//
//  MEParentsInfoView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/4.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEParentsInfoView.h"

@implementation MEParentsInfoView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubViews];
    }
    return self;
}

- (void)customSubViews {
    _tipLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
    _tipLab.font = UIFontPingFangSC(16);
    _tipLab.textColor = UIColorFromRGB(0x609EE1);
    _tipLab.textAlignment = NSTextAlignmentLeft;
    _tipLab.text = @"爸爸信息";
    [self addSubview: _tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(20.f);
    }];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.font = UIFontPingFangSC(15);
    _nameTextField.textColor = UIColorFromRGB(0x284E6C);
    _nameTextField.delegate = self;
    _nameTextField.borderStyle = UITextBorderStyleNone;
    [self addSubview: self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLab.mas_bottom).mas_offset(12.f);
        make.left.mas_equalTo(self.tipLab);
        [self.nameTextField sizeToFit];
        make.height.mas_equalTo(22.f);
    }];
    
    MEBaseScene *sepView = [[MEBaseScene alloc] init];
    sepView.backgroundColor = _nameTextField.textColor;
    [self addSubview: sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(ME_LAYOUT_LINE_HEIGHT);
        make.left.mas_equalTo(self.nameTextField.mas_right).mas_offset(3.f);
        make.centerY.mas_equalTo(self.nameTextField);
    }];
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.font = UIFontPingFangSC(15);
    _phoneTextField.textColor = UIColorFromRGB(0x284E6C);
    _phoneTextField.delegate = self;
    _phoneTextField.borderStyle = UITextBorderStyleNone;
    [self addSubview: self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameTextField);
        make.left.mas_equalTo(sepView.mas_right).mas_offset(3.f);
        [self.phoneTextField sizeToFit];
        make.height.mas_equalTo(22.f);
    }];

    _addressTextField = [[UITextField alloc] init];
    _addressTextField.font = UIFontPingFangSC(15);
    _addressTextField.textColor = UIColorFromRGB(0x284E6C);
    _addressTextField.delegate = self;
    _addressTextField.borderStyle = UITextBorderStyleNone;
    [self addSubview: _addressTextField];
    [_addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameTextField.mas_bottom).mas_offset(15.f);
        make.left.mas_equalTo(self.nameTextField);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(22.f);
    }]; 
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.currentUser.userType == MEPBUserRole_Gardener) {
        return false;
    }
    if (![textField.text isEqualToString: @"-"]) {
        textField.text = @"";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_EDIT_BABY_ARCHIVES" object: nil];
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
