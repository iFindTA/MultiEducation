//
//  MEUpdatePasswordProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUpdatePasswordProfile.h"
#import "MEEditScene.h"
#import "MERePasswordVM.h"
#import "NSString+Md5String.h"
#import <YYKit.h>
#import "MeuserData.pbobjc.h"

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
    [self customNavigation];
    
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

- (void)customNavigation {
    NSString *title = @"修改密码";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)confirmButtonTouchEvent {
    FscUserPb *userPb = [[FscUserPb alloc] init];
    MERePasswordVM *vm = [MERePasswordVM vmWithModel: userPb];
    
    if (!(self.newPwd.textfield.text.length >= 6 && self.newPwd.textfield.text.length <= 12)) {
        [SVProgressHUD showErrorWithStatus: @"请输入6-12位的密码！"];
        return;
    }
    
    if (![self.reNewPwd.textfield.text isEqualToString: self.newPwd.textfield.text]) {
        [SVProgressHUD showErrorWithStatus: @"两次密码输入不一致！"];
        return;
    }
    
    userPb.repassword = [[self.oldPwd.textfield.text dataUsingEncoding: NSUTF8StringEncoding] md5String];
    userPb.password = [[self.newPwd.textfield.text dataUsingEncoding: NSUTF8StringEncoding] md5String];

    NSData *data = [userPb data];
    
    weakify(self);
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        [self logout];
        [SVProgressHUD showErrorWithStatus: @"密码已修改，请重新登录"];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)logout {
     [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool: YES] forKey: ME_USER_DID_INITIATIVE_LOGOUT];
    [self splash2ChangeDisplayStyle: MEDisplayStyleAuthor];
}

#pragma mark - lazyloading
- (MEEditScene *)oldPwd {
    if (!_oldPwd) {
        _oldPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _oldPwd.textfield.secureTextEntry = YES;
        _oldPwd.textfield.placeholder = @"原密码";
    }
    return _oldPwd;
}

- (MEEditScene *)newPwd {
    if (!_newPwd) {
        _newPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _newPwd.textfield.secureTextEntry = YES;
        _newPwd.textfield.placeholder = @"新密码";
    }
    return _newPwd;
}

- (MEEditScene *)reNewPwd {
    if (!_reNewPwd) {
        _reNewPwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _reNewPwd.textfield.secureTextEntry = YES;
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
