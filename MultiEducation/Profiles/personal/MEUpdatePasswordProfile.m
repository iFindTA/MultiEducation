//
//  MEUpdatePasswordProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUpdatePasswordProfile.h"
#import "MEEditScene.h"

static CGFloat const ROW_HEIGHT = 54.f;

@interface MEUpdatePasswordProfile ()

@property (nonatomic, strong) MEEditScene *oldPwd;
@property (nonatomic, strong) MEEditScene *newPwd;
@property (nonatomic, strong) MEEditScene *reNewPwd;
@property (nonatomic, strong) MEBaseButton *confirmBtn;

@end

@implementation MEUpdatePasswordProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    [self.view addSubview: self.oldPwd];
    [self.view addSubview: self.newPwd];
    [self.view addSubview: self.reNewPwd];
    [self.view addSubview: self.confirmBtn];

    //layout
    [self.oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
        make.height.mas_equalTo(ROW_HEIGHT);
    }];
    
    [self.newPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.oldPwd.mas_bottom);
        make.height.mas_equalTo(ROW_HEIGHT);
    }];
    
    [self.reNewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.newPwd.mas_bottom);
        make.height.mas_equalTo(ROW_HEIGHT);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(13.f);
        make.right.mas_equalTo(-13.f);
        make.top.mas_equalTo(self.reNewPwd.mas_bottom).mas_offset(35.f);
        make.height.mas_equalTo(44.f);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)confirmButtonTouchEvent {
    
}

#pragma mark - lazyloading
- (MEEditScene *)oldPwd {
    if (!_oldPwd) {
        _oldPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _oldPwd.textfield.placeholder = @"原密码";
    }
    return _oldPwd;
}

- (MEEditScene *)newPwd {
    if (!_newPwd) {
        _newPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _newPwd.textfield.placeholder = @"新密码";
    }
    return _newPwd;
}

- (MEEditScene *)reNewPwd {
    if (!_reNewPwd) {
        _reNewPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _reNewPwd.textfield.placeholder = @"确认新密码";
    }
    return _reNewPwd;
}

- (MEBaseButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[MEBaseButton alloc] init];
        [_confirmBtn setTitle: @"确认修改" forState: UIControlStateNormal];
        _confirmBtn.titleLabel.font = UIFontPingFangSC(14);
        [_confirmBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0x609ee1);
        [_confirmBtn addTarget: self action: @selector(confirmButtonTouchEvent) forControlEvents: UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
