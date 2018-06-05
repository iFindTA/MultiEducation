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
    self.dadView.nameTextField.text = [self resetStringFormatter: pb.fatherName];
    self.dadView.phoneTextField.text = [self resetStringFormatter: pb.fatherMobile];
    self.dadView.addressTextField.text = [self resetStringFormatter: pb.fatherWorkUnit];
    
    self.momView.nameTextField.text = [self resetStringFormatter: pb.motherName];
    self.momView.phoneTextField.text = [self resetStringFormatter: pb.motherMobile];
    self.momView.addressTextField.text = [self resetStringFormatter: pb.motherWorkUnit];
    self.tipTextView.text = [self resetStringFormatter: pb.warnItem];
}

- (NSString *)resetStringFormatter:(NSString *)string {
    if (!string || [string isEqualToString: @""]) {
        return @"-";
    } else {
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

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_EDIT_BABY_ARCHIVES" object: nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
    }
    return true;
}



@end
