//
//  METextFieldCell.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METextFieldCell.h"
#import <IQKeyboardManager.h>

@implementation METextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.input.delegate = self;
    IQKeyboardManager.sharedManager.enable = true;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = true;
    // Initialization code
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100.f);
    }];
    
    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
        make.left.mas_equalTo(self.titleLab.mas_right);
    }];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString: self.input.placeholder attributes: @{NSForegroundColorAttributeName: UIColorFromRGB(0x999999), NSFontAttributeName: self.input.font}];
    self.input.attributedPlaceholder = attStr;
}

- (void)updateLayout {
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100.f);
        make.left.mas_equalTo(self.contentView).mas_offset(33.f);
    }];
    
    [self.input mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.right.mas_equalTo(self.contentView).mas_offset(-51.f);
        make.height.mas_equalTo(30.f);
        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(10.f);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
