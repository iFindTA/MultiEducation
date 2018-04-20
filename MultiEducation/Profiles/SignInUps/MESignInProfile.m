//
//  MESignInProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/12.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "MEVerifyCodeVM.h"
#import "MESignInProfile.h"
#import "MESignInputField.h"
#import "UITextField+MaxLength.h"
#import <JKCountDownButton/JKCountDownButton.h>

@interface MESignInProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL whetherDidExcuteBlockBefore;

/**
 mobile & pwd
 */
@property (nonatomic, strong) MESignInputField *inputMobile;
@property (nonatomic, strong) MESignInputField *inputPwd;

/**
 mobile & code
 */
@property (nonatomic, strong) MEBaseScene *codeSignPanel;
@property (nonatomic, strong) MESignInputField *inputCode;

/**
 sign-in mode pwd or code
 */
@property (nonatomic, strong) MEBaseButton *modeChangeBtn;

@end

@implementation MESignInProfile

- (id)__initCallback:(void(^)(void))block {
    self = [super init];
    if (self) {
        if (block) {
            block();
        }
    }
    return self;
}

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
        //NSLog(@"收到的参数:%@", params);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavigationBar];
    
    //welcom
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
    label.text = @"欢迎登录多元幼教";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(adoptValue(ME_LAYOUT_SUBBAR_HEIGHT * 2));
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    //mobile
    MEBaseImageView *icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"signin_mobile"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(ME_LAYOUT_SUBBAR_HEIGHT);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    UIColor *textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    MESignInputField *input = [[MESignInputField alloc] initWithFrame:CGRectZero];
    input.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE-1);
    input.placeholder = @"手机号码";
    input.textColor = textColor;
    input.maxLength = ME_REGULAR_MOBILE_LENGTH;
    input.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:input];
    self.inputMobile = input;
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(icon).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
    }];
    MEBaseScene *line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    line.backgroundColor =UIColorFromRGB(ME_THEME_COLOR_LINE);
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input.mas_bottom).offset(ME_LAYOUT_MARGIN * 0.5);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    //password
    icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"signin_pwd"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    input = [[MESignInputField alloc] initWithFrame:CGRectZero];
    input.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE-1);
    input.placeholder = @"密码";
    input.textColor = textColor;
    input.secureTextEntry = true;
    input.maxLength = ME_REGULAR_PASSWD_LEN_MAX;
    input.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:input];
    self.inputPwd = input;
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(icon).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
    }];
    line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    line.backgroundColor =UIColorFromRGB(ME_THEME_COLOR_LINE);
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input.mas_bottom).offset(ME_LAYOUT_MARGIN * 0.5);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    //code
    MEBaseScene *codePanel = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    codePanel.backgroundColor = [UIColor whiteColor];
    codePanel.hidden = true;
    [self.view addSubview:codePanel];
    self.codeSignPanel = codePanel;
    [codePanel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputMobile.mas_bottom).offset(ME_LAYOUT_MARGIN * 0.5 + 1);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(line);
    }];
    icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.codeSignPanel addSubview:icon];
    icon.image = [UIImage imageNamed:@"signin_code"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeSignPanel).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.codeSignPanel).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    //
    UIColor *themeColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    JKCountDownButton *countDown = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    countDown.titleLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE - 1);
    [countDown setTitle:@"验证码" forState:UIControlStateNormal];
    [countDown setTitleColor:themeColor forState:UIControlStateNormal];
    countDown.layer.cornerRadius = ME_LAYOUT_SUBBAR_HEIGHT * 0.75 * 0.5;
    countDown.layer.masksToBounds = true;
    countDown.layer.borderWidth = ME_LAYOUT_LINE_HEIGHT;
    countDown.layer.borderColor = themeColor.CGColor;
    countDown.backgroundColor = [UIColor whiteColor];
    [self.codeSignPanel addSubview:countDown];
    [countDown makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon.mas_centerY);
        make.right.equalTo(self.codeSignPanel).offset(-ME_LAYOUT_BOUNDARY);
        make.width.equalTo(adoptValue(ME_HEIGHT_NAVIGATIONBAR*3));
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT * 0.75);
    }];
    weakify(self)
    [countDown countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        countDownButton.enabled = NO;
        [countDownButton startCountDownWithSecond:59];
        strongify(self)
        [self sendSignInVerifyCodeEvent];
        [countDownButton countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [countDownButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取";
        }];
    }];
    input = [[MESignInputField alloc] initWithFrame:CGRectZero];
    input.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE-1);
    input.placeholder = @"验证码";
    input.textColor = textColor;
    input.maxLength = ME_REGULAR_CODE_LEN_MAX;
    input.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeSignPanel addSubview:input];
    self.inputCode = input;//input.backgroundColor = [UIColor pb_randomColor];
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(icon).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(countDown.mas_left).offset(-ME_LAYOUT_BOUNDARY);
    }];
    line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    line.backgroundColor =UIColorFromRGB(ME_THEME_COLOR_LINE);
    [self.codeSignPanel addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input.mas_bottom).offset(ME_LAYOUT_MARGIN * 0.5);
        make.left.equalTo(self.codeSignPanel).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.codeSignPanel);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    
    // sign in
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    
    //code sign-in
    font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    MEBaseButton *codeBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    codeBtn.titleLabel.font = font;
    [codeBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    [codeBtn setTitle:@"密码登录" forState:UIControlStateSelected];
    [codeBtn setTitleColor:textColor forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(exchangeSignInMethod2Code:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];self.modeChangeBtn = codeBtn;
    [codeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(btn);
        make.height.equalTo(ME_HEIGHT_STATUSBAR);
    }];
    //register user
    MEBaseButton *registerBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = font;
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:textColor forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAccountTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(btn);
        make.height.equalTo(ME_HEIGHT_STATUSBAR);
    }];
    //游客模式
    BOOL showVisitorMode = true;
    if ([[self.params allKeys] containsObject:ME_SIGNIN_DIDNOT_SHOW_VISITOR_FUNC]) {
        showVisitorMode = [self.params pb_boolForKey:ME_SIGNIN_DIDNOT_SHOW_VISITOR_FUNC];
    }
    if (showVisitorMode) {
        font = UIFontPingFangSC(METHEME_FONT_SUBTITLE - 1);
        btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        [btn setTitle:@"随便逛逛 >>" forState:UIControlStateNormal];
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(signedInAsTouristTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(ME_HEIGHT_TABBAR * 2);
            make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        }];
    }
    
#if DEBUG
    //teacher
    self.inputMobile.text = @"18751732219";
    self.inputPwd.text = @"123456";
    //parent
//    self.inputMobile.text = @"15005788070";
//    self.inputPwd.text = @"123456";
#endif
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNeedsStatusBarAppearanceUpdate];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self runCallbackBeforeSignin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Touch Events

- (void)exchangeSignInMethod2Code:(MEBaseButton *)btn {
    btn.selected = !btn.selected;
    self.codeSignPanel.hidden = !btn.selected;
}

- (void)registerAccountTouchEvent {
    NSURL *routeUrl = [MEDispatcher profileUrlWithClass:@"MESignUpProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
    NSError *error = [MEDispatcher openURL:routeUrl withParams:self.params];
    [self handleTransitionError:error];
}

- (void)loginTouchEvent {
    
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    [pb setLoginName:mobile];
    //登录方式
    BOOL whetherPwdSignInMode = !self.modeChangeBtn.selected;
    if (whetherPwdSignInMode) {
        //check pwd
        NSString *pwd = self.inputPwd.text;
        if (pwd.length < ME_REGULAR_PASSWD_LEN_MIN) {
            NSString *errString = PBFormat(@"请输入%zd~%zd位密码！", ME_REGULAR_PASSWD_LEN_MIN, ME_REGULAR_PASSWD_LEN_MAX);
            [SVProgressHUD showErrorWithStatus:errString];
            return;
        }
        [pb setPassword:pwd];
    } else {
        //check code
        NSString *code = self.inputCode.text;
        if (code.length < ME_REGULAR_CODE_LEN_MIN) {
            NSString *errString = PBFormat(@"请输入%zd~%zd位验证码！", ME_REGULAR_CODE_LEN_MIN, ME_REGULAR_CODE_LEN_MAX);
            [SVProgressHUD showErrorWithStatus:errString];
            return;
        }
    }
    //apns token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:ME_APPLICATION_APNE_TOKEN];
    [pb setAppleToken:token];
    //device info
    MEPBPhoneInfo *info = [MEUserVM getDeviceInfo];
    pb.phoneInfo = info;
    //goto signin
    MEUserVM *vm = [MEUserVM vmWithPB:pb];
    NSData *pbdata = [pb data];
    weakify(self)
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBUserList *userList = [MEPBUserList parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
        } else {
            [self handleMulticastUserIdentitySwitchEvent:userList];
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
    }];
}

/**
 发送验证码
 */
- (void)sendSignInVerifyCodeEvent {
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
#if DEBUG
    [pb setLoginName:@"2"];
#else
    [pb setLoginName:mobile];
#endif
    //goto signin
    MEVerifyCodeVM *vm = [MEVerifyCodeVM vmWithPB:pb];
    NSData *pbdata = [pb data];
    weakify(self)
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        //strongify(self)
        [SVProgressHUD showSuccessWithStatus:@"发送验证码成功！"];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
    }];
}

- (void)runCallbackBeforeSignin {
    if (!self.whetherDidExcuteBlockBefore) {
        void(^callBefore)(void) = [self.params objectForKey:ME_DISPATCH_KEY_CALLBEFORE];
        if (callBefore) {
            callBefore();
            self.whetherDidExcuteBlockBefore = true;
        }
    }
}

#pragma mark --- 处理多用户登录身份选择

- (void)handleMulticastUserIdentitySwitchEvent:(MEPBUserList*)list {
    if (list.userListArray.count <= 1) {
        //只有一个用户登录
        MEPBUser *user = list.userListArray.firstObject;
        [MEUserVM saveUser:user];
        [self.appDelegate updateCurrentSignedInUser:user];
        //登录成功之后的操作
        //有 block 则先执行
        void(^signInCallback)(void) = [self.params objectForKey:ME_DISPATCH_KEY_CALLBACK];
        if (signInCallback) {
            signInCallback();
        }
        BOOL shouldGoback = [self.params pb_boolForKey:ME_SIGNIN_SHOULD_GOBACKSTACK_AFTER_SIGNIN];
        if (shouldGoback) {
            [self defaultGoBackStack];
        } else {
            [self splash2ChangeDisplayStyle:MEDisplayStyleMainSence];
        }
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:list forKey:@"userList"];
        if (self.params) {
            [params addEntriesFromDictionary:self.params];
        }
        NSURL *url = [MEDispatcher profileUrlWithClass:@"MEUserIdentitySwitchProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
        NSError *err = [MEDispatcher openURL:url withParams:params.copy];
        [self handleTransitionError:err];
    }
}

#pragma mark --- 游客登录模式
- (void)signedInAsTouristTouchEvent {
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    //apns token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:ME_APPLICATION_APNE_TOKEN];
    [pb setAppleToken:token];
    //device info
    MEPBPhoneInfo *info = [MEUserVM getDeviceInfo];
    pb.phoneInfo = info;
    //goto signin
    MEUserVM *vm = [MEUserVM vmWithPB:pb];
    NSData *pbdata = [pb data];
    weakify(self)
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBUserList *userList = [MEPBUserList parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
        } else {
            MEPBUser *user = userList.userListArray.firstObject;
            [MEUserVM saveUser:user];
            [self.appDelegate updateCurrentSignedInUser:user];
            //登录成功之后的操作
            [self splash2ChangeDisplayStyle:MEDisplayStyleVisitor];
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
    }];
    
    //[self splash2ChangeDisplayStyle:MEDisplayStyleVisitor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
