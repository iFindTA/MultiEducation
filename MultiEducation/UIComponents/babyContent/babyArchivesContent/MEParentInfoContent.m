//
//  MEParentInfoContent.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEParentInfoContent.h"
#import "MEParentsInfoView.h"
#import "MebabyGrowth.pbobjc.h"
#import "UITextView+Placeholder.h"

@interface MEParentInfoContent() <UITextViewDelegate>

@end

@implementation MEParentInfoContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self customSubviews];
    }
    return self;
}

- (void)customSubviews {
    
    self.dadView = [[MEParentsInfoView alloc] initWithFrame: CGRectZero];
    [self addSubview: self.dadView];
    [self.dadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(adoptValue(27.f));
        make.top.mas_equalTo(self).mas_offset(adoptValue(25.f));
        make.right.mas_equalTo(self).mas_offset(-adoptValue(27.f));
        make.height.mas_equalTo(100.f);
    }];
    
    self.momView = [[MEParentsInfoView alloc] initWithFrame: CGRectZero];
    self.momView.tipLab.text = @"妈妈信息";
    [self addSubview: self.momView];
    [self.momView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.dadView);
        make.top.mas_equalTo(self.dadView.mas_bottom).mas_offset(adoptValue(29.f));
    }];
    
    MEBaseLabel *tipLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
    tipLab.font = UIFontPingFangSC(16);
    tipLab.textColor = UIColorFromRGB(0xC42828);
    tipLab.textAlignment = NSTextAlignmentLeft;
    tipLab.text = @"注意事项";
    [self addSubview: tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dadView);
        make.top.mas_equalTo(self.momView.mas_bottom).mas_offset(adoptValue(27.f));
        make.height.mas_equalTo(adoptValue(22.f));
        make.width.mas_equalTo(100.f);
    }];
    
    self.tipTextView = [[UITextView alloc] initWithFrame: CGRectZero];
    self.tipTextView.font = UIFontPingFangSC(15.f);
    self.tipTextView.textColor = UIColorFromRGB(0x284E6C);
    [self addSubview: self.tipTextView];
    [self.tipTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).mas_offset(adoptValue(16.f));
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-adoptValue(16.f));
        make.trailing.leading.mas_equalTo(self.dadView);
    }];
}

- (void)setData:(GuStudentArchivesPb *)pb {
    self.dadView.nameTextField.text = [self resetStringFormatter: pb.fatherName placeHolder: @"爸爸姓名" textField: self.dadView.nameTextField];

    self.dadView.phoneTextField.text = [self resetStringFormatter: pb.fatherMobile placeHolder: @"爸爸手机号" textField: self.dadView.phoneTextField];

    self.dadView.addressTextField.text = [self resetStringFormatter: pb.fatherWorkUnit placeHolder: @"爸爸工作单位" textField: self.dadView.addressTextField];

    self.momView.nameTextField.text = [self resetStringFormatter: pb.motherName placeHolder: @"妈妈姓名" textField: self.momView.nameTextField];

    self.momView.phoneTextField.text = [self resetStringFormatter: pb.motherMobile placeHolder: @"妈妈手机号" textField: self.momView.phoneTextField];

    self.momView.addressTextField.text = [self resetStringFormatter: pb.motherWorkUnit placeHolder: @"妈妈工作单位" textField: self.momView.addressTextField];

    self.tipTextView.text = pb.warnItem;
    [self.tipTextView setPlaceholder: @"  请家长围绕孩子的健康、睡眠、饮食、教育等写下有关孩子在幼儿园需要特别注意的事项" placeholdColor: UIColorFromRGB(0x999999)];
}

- (NSString *)resetStringFormatter:(NSString *)string placeHolder:(NSString *)placeholder textField:(UITextField *)textField {
    if (!string || [string isEqualToString: @""]) {
        textField.placeholder = placeholder;
        return @"";
    } else {
        textField.placeholder = placeholder;
        return string;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.currentUser.userType == MEPBUserRole_Gardener) {
        return false;
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
    }
    return true;
}



@end
