//
//  MELoginTextScene.m
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MELoginTextScene.h"

@implementation MELoginTextScene
{
    MEBaseButton *_codeBtn;
}

- (instancetype)initWithImageNme:(NSString *)imgName andPlaceHolder:(NSString *)placeHolder andCodeBtnTitle:(NSString *)btnTitle {
    self = [super init];
    if (self) {
        [self setTextSubviewsWithImageNme:imgName andPlaceHolder:placeHolder andCodeBtnTitle:btnTitle];
    }
    return self;
}

- (void)setTextSubviewsWithImageNme:(NSString *)imgName andPlaceHolder:(NSString *)placeHolder andCodeBtnTitle:(NSString *)btnTitle{
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:imgName];
    [self addSubview:iconImgView];
    weakify(self);
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.mas_equalTo(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(15, 25));
    }];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectNull];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    textField.placeholder = placeHolder;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.right).with.offset(10);
        make.height.mas_equalTo(iconImgView.height);
        make.centerY.mas_equalTo(iconImgView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.mas_equalTo(self.mas_left);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    if (![btnTitle isEqualToString:@""]) {
        UIImage *codeBtnBg = [UIImage imageNamed:@"login_text_code_btn_bg"];
        MEBaseButton *codeBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:codeBtn];
        [codeBtn setTitle:btnTitle forState:UIControlStateNormal];
        _codeBtn = codeBtn;
        [codeBtn setTitleColor:UIColorFromRGB(0x00000) forState:UIControlStateNormal];
        [codeBtn setBackgroundImage:codeBtnBg forState:UIControlStateNormal];
        [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(10);
            make.centerY.mas_equalTo(iconImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(codeBtnBg.size.width, codeBtnBg.size.height));
        }];
    }
}

- (void)setCodeBtnTitle:(NSString *)btnTitle {
    [_codeBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.loginTextClick) {
        self.loginTextClick(TextSceneActionTypeTextChange, self.textType, string);
    }
    
    return YES;
}


@end
