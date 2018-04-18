//
//  MESignUpProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MERegisterVM.h"
#import "MEVerifyCodeVM.h"
#import "MESignUpProfile.h"
#import "MESignInputField.h"
#import "UITextField+MaxLength.h"
#import <YYKit/NSAttributedString+YYText.h>
#import <JKCountDownButton/JKCountDownButton.h>

@interface MESignUpProfile ()

/**
 mobile & pwd
 */
@property (nonatomic, strong) MESignInputField *inputMobile;
@property (nonatomic, strong) MESignInputField *inputPwd;
@property (nonatomic, strong) MESignInputField *inputClassno;
@property (nonatomic, strong) MESignInputField *inputCode;

@end

@implementation MESignUpProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavigationBar];
    
    //welcom
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
    label.text = @"注册账号";
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
    UIFont *inputFont = UIFontPingFangSCMedium(METHEME_FONT_TITLE-1);
    UIColor *textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    MESignInputField *input = [[MESignInputField alloc] initWithFrame:CGRectZero];
    input.font = inputFont;
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
    input.font = inputFont;
    input.placeholder = @"密码";
    input.textColor = textColor;
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
    //class no
    icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"signup_classno"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    input = [[MESignInputField alloc] initWithFrame:CGRectZero];
    input.font = inputFont;
    input.placeholder = @"班级码";
    input.textColor = textColor;
    input.maxLength = ME_REGULAR_CODE_LEN_MAX;
    input.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:input];
    self.inputClassno = input;
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
    icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"signin_code"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    UIColor *themeColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    JKCountDownButton *countDown = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    countDown.titleLabel.font = inputFont;
    [countDown setTitle:@"验证码" forState:UIControlStateNormal];
    [countDown setTitleColor:themeColor forState:UIControlStateNormal];
    countDown.layer.cornerRadius = ME_LAYOUT_SUBBAR_HEIGHT * 0.75 * 0.5;
    countDown.layer.masksToBounds = true;
    countDown.layer.borderWidth = ME_LAYOUT_LINE_HEIGHT;
    countDown.layer.borderColor = themeColor.CGColor;
    countDown.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:countDown];
    [countDown makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon.mas_centerY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
        make.width.equalTo(adoptValue(ME_HEIGHT_NAVIGATIONBAR*3));
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT * 0.75);
    }];
    weakify(self)
    [countDown countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        countDownButton.enabled = NO;
        [countDownButton startCountDownWithSecond:59];
        strongify(self)
        [self sendRegisterVerifyCodeEvent];
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
    input.font = inputFont;
    input.placeholder = @"验证码";
    input.textColor = textColor;
    input.maxLength = ME_REGULAR_CODE_LEN_MAX;
    input.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:input];//input.backgroundColor = [UIColor pb_randomColor];
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(icon).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(countDown.mas_left).offset(-ME_LAYOUT_BOUNDARY);
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
    // sign in
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [btn setTitle:@"立即注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    //protocol
    NSString *protocol = @"多元幼教用户服务条款";
    NSString *protocolString = @"点击立即注册及代表您同意多元幼教用户服务条款";
    NSRange protocolRange = [protocolString rangeOfString:protocol];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:protocolString];

    [text setTextHighlightRange:protocolRange color:themeColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        strongify(self)
        [self displayUserRegisterProtocol];
    }];
    MEBaseLabel *protocolLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    protocolLabel.font = UIFontPingFangSCBold(METHEME_FONT_SUBTITLE-2);
    [protocolLabel setAttributedText:text];
    
    [self.view addSubview:protocolLabel];
    [protocolLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.top.equalTo(btn.mas_bottom).offset(ME_LAYOUT_BOUNDARY * 0.5);
        make.height.equalTo(ME_HEIGHT_STATUSBAR);
    }];
    //exchange to sign-in
    font = UIFontPingFangSC(METHEME_FONT_SUBTITLE - 1);
    btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitle:@"已有账号，去登录" forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exchangeSplash2Sign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-ME_LAYOUT_MARGIN);
        make.width.equalTo(ME_HEIGHT_TABBAR * 2);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNeedsStatusBarAppearanceUpdate];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Touch Event

- (void)displayUserRegisterProtocol {
    NSDictionary *params = @{@"title":@"多元幼教用户条款", @"url":@"http://baidu.com/"};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEBrowserProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
}

- (void)exchangeSplash2Sign {
    [self defaultGoBackStack];
}

/**
 发送验证码
 */
- (void)sendRegisterVerifyCodeEvent {
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
#if DEBUG
    [pb setLoginName:@"13023622337"];
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

- (void)registerTouchEvent {
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //check pwd
    NSString *pwd = self.inputPwd.text;
    if (pwd.length < ME_REGULAR_PASSWD_LEN_MIN) {
        NSString *errString = PBFormat(@"请输入%zd~%zd位密码！", ME_REGULAR_PASSWD_LEN_MIN, ME_REGULAR_PASSWD_LEN_MAX);
        [SVProgressHUD showErrorWithStatus:errString];
        return;
    }
    //check classno
    NSString *classno = self.inputClassno.text;
    if (classno.length < ME_REGULAR_CLASSNO_LEN_MIX) {
        NSString *errString = PBFormat(@"请输入%zd~%zd位班级码！", ME_REGULAR_CLASSNO_LEN_MIX, ME_REGULAR_CLASSNO_LEN_MAX);
        [SVProgressHUD showErrorWithStatus:errString];
        return;
    }
    //check code
    NSString *code = self.inputCode.text;
    if (code.length < ME_REGULAR_CODE_LEN_MIN) {
        NSString *errString = PBFormat(@"请输入%zd~%zd位验证码！", ME_REGULAR_CODE_LEN_MIN, ME_REGULAR_CODE_LEN_MAX);
        [SVProgressHUD showErrorWithStatus:errString];
        return;
    }
    //TODO:// sigin-in action
    MEPBUser *user = [[MEPBUser alloc] init];
    [user setMobile:mobile];
    [user setPassword:pwd];
    //user
    MERegisterVM *vm = [[MERegisterVM alloc] init];
    
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
