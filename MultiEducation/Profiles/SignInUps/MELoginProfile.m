//
//  MELoginProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "MEVerifyCodeVM.h"
#import "MELoginProfile.h"
#import "MEMulticastRole.h"
#import "UITextField+MaxLength.h"
#import <YYKit/NSAttributedString+YYText.h>
#import <JKCountDownButton/JKCountDownButton.h>

@interface MELoginProfile ()

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) MEBaseButton *modeBtn;
@property (nonatomic, strong) MEBaseScene *pwdScene;
@property (nonatomic, strong) UITextField *inputMobile;
@property (nonatomic, strong) UITextField *inputCode;

@property (nonatomic, strong) MEBaseLabel *helpLabel;

@property (nonatomic, strong) MEMulticastRole *multicastRoleScene;

@end

@implementation MELoginProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"login_bg"];
    MEBaseImageView *imgView = [[MEBaseImageView alloc] initWithImage:image];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //bg
    MEBaseScene *signBgScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    signBgScene.layer.cornerRadius = ME_LAYOUT_MARGIN*2.5;
    signBgScene.layer.masksToBounds = true;
    [self.view addSubview:signBgScene];
    [signBgScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(adoptValue(130));
        make.left.equalTo(self.view).offset(ME_LAYOUT_MARGIN*2.5);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_MARGIN*2.5);
    }];
    //title
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE+ME_LAYOUT_OFFSET);
    UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    MEBaseLabel *title = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    title.font = font;
    title.textColor = fontColor;
    title.text = @"登录多元幼教";
    [signBgScene addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY+ME_LAYOUT_OFFSET);
        make.left.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(28);
    }];
    //icon
    image = [UIImage imageNamed:@"login_icon_account"];
    MEBaseImageView *icon = [[MEBaseImageView alloc] initWithImage:image];
    [signBgScene addSubview:icon];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(ME_LAYOUT_MARGIN*2.5);
        make.left.equalTo(title);
    }];
    font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-1);
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.textColor = fontColor;
    label.text = @"手机号";
    [signBgScene addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_MARGIN*0.5);
        make.centerY.equalTo(icon.mas_centerY);
    }];
    //input background
    MEBaseScene *inputBg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    inputBg.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [signBgScene addSubview:inputBg];
    [inputBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(ME_LAYOUT_MARGIN*0.5);
        make.left.equalTo(title);
        make.right.equalTo(signBgScene).offset(-ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];
    UITextField *input = [[UITextField alloc] initWithFrame:CGRectZero];
    input.font = UIFontPingFangSC(METHEME_FONT_TITLE-1);
    input.textColor = fontColor;
    input.placeholder = @"请输入手机号";
    input.keyboardType = UIKeyboardTypePhonePad;
    input.maxLength = ME_REGULAR_MOBILE_LENGTH;
    [inputBg addSubview:input];
    self.inputMobile = input;
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(inputBg).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN));
    }];
    //code
    image = [UIImage imageNamed:@"login_icon_code"];
    icon = [[MEBaseImageView alloc] initWithImage:image];
    [signBgScene addSubview:icon];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBg.mas_bottom).offset(ME_LAYOUT_MARGIN*1.5);
        make.left.equalTo(inputBg);
    }];
    font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-1);
    label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.textColor = fontColor;
    label.text = @"验证码";
    [signBgScene addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_MARGIN*0.5);
        make.centerY.equalTo(icon.mas_centerY);
    }];
    //input background
    inputBg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    inputBg.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [signBgScene addSubview:inputBg];
    [inputBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(ME_LAYOUT_MARGIN*0.5);
        make.left.equalTo(title);
        make.right.equalTo(signBgScene).offset(-ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];
    //seperator line
    UIColor *lineColor = UIColorFromRGB(0x4B8EFF);
    MEBaseScene *line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    [inputBg addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(inputBg).offset(ME_HEIGHT_TABBAR);
        make.top.equalTo(inputBg).offset(ME_LAYOUT_MARGIN);
        make.bottom.equalTo(inputBg).offset(-ME_LAYOUT_MARGIN);
        make.width.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    //count down
    JKCountDownButton *countDown = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    countDown.titleLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE - 1);
    [countDown setTitle:@"获取验证码" forState:UIControlStateNormal];
    [countDown setTitleColor:lineColor forState:UIControlStateNormal];
    countDown.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [inputBg addSubview:countDown];
    [countDown makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBg).offset(ME_LAYOUT_MARGIN);
        make.bottom.equalTo(inputBg).offset(-ME_LAYOUT_MARGIN);
        make.right.equalTo(inputBg);
        make.left.equalTo(line.mas_right);
    }];
    weakify(self)
    [countDown countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        strongify(self)
        NSString *mobile = self.inputMobile.text;
        if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
            return;
        }
        if (self.helpLabel.isHidden) {
            self.helpLabel.hidden = false;
        }
        countDownButton.enabled = NO;
        [countDownButton startCountDownWithSecond:59];
        [self sendLoginSMSCode];
        [countDownButton countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [countDownButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取";
        }];
    }];
    input = [[UITextField alloc] initWithFrame:CGRectZero];
    input.font = UIFontPingFangSC(METHEME_FONT_TITLE-1);
    input.textColor = fontColor;
    input.placeholder = @"请输入验证码";
    input.keyboardType = UIKeyboardTypeNamePhonePad;
    input.maxLength = ME_REGULAR_CODE_LEN_MAX;
    [inputBg addSubview:input];
    self.inputCode = input;
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(inputBg).offset(ME_LAYOUT_MARGIN);
        make.bottom.equalTo(inputBg).offset(-ME_LAYOUT_MARGIN);
        make.right.equalTo(line.mas_left);
    }];
    //验证码提示
    font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-1);
    NSString *protocol = @"联系客服";
    NSString *protocolString = @"验证码收不到？请联系客服";
    NSRange protocolRange = [protocolString rangeOfString:protocol];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:protocolString];
    [text setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x999999)}];
    [text setTextHighlightRange:protocolRange color:lineColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        strongify(self)
        [self displayContactService];
    }];
    MEBaseLabel *protocolLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    protocolLabel.numberOfLines = 2;
    protocolLabel.lineBreakMode = NSLineBreakByCharWrapping;
    protocolLabel.font = font;
    [protocolLabel setAttributedText:text];
    [signBgScene addSubview:protocolLabel];
    self.helpLabel = protocolLabel;
    protocolLabel.hidden = true;
    [protocolLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBg.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.right.equalTo(inputBg);
    }];
    // sign in
    font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = ME_HEIGHT_NAVIGATIONBAR * 0.5;
    btn.layer.masksToBounds = true;
    btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(userDidTouchSignin) forControlEvents:UIControlEventTouchUpInside];
    [signBgScene addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(protocolLabel.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY*1.5);
        make.right.equalTo(signBgScene).offset(-ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];
    
    //bottom margin
    [signBgScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
    }];
    
    //*游客模式
     BOOL showVisitorMode = true;
     if ([[self.params allKeys] containsObject:ME_SIGNIN_DID_SHOW_VISITOR_FUNC]) {
         showVisitorMode = [self.params pb_boolForKey:ME_SIGNIN_DID_SHOW_VISITOR_FUNC];
     }
     if (showVisitorMode) {
         font = UIFontPingFangSC(METHEME_FONT_SUBTITLE - 1);
         btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
         btn.titleLabel.font = font;
         [btn setTitle:@"随便逛逛" forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    //家长
    self.inputMobile.text = @"13612345677";
    self.inputCode.text = @"999999";
    //老师
    //    self.inputMobile.text = @"13023622337";
    //    self.inputPwd.text = @"123456";
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 发送登录验证码
 */
- (void)sendLoginSMSCode {
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    [pb setLoginName:mobile];
    //goto signin
    MEVerifyCodeVM *vm = [MEVerifyCodeVM vmWithPB:pb];
    NSData *pbdata = [pb data];
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        [SVProgressHUD showSuccessWithStatus:@"已发送，请注意查收！"];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

/**
 联系客服
 */
- (void)displayContactService {
    NSString *urlStr = @"profile://root@METemplateProfile";
    NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"联系我们", ME_CORDOVA_KEY_STARTPAGE:@"contact_us.html"};
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)userDidTouchSignin {
    //check mobile
    NSString *mobile = self.inputMobile.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    [pb setLoginName:mobile];
    //check code
    NSString *code = self.inputCode.text;
    if (code.length < ME_REGULAR_CODE_LEN_MIN) {
        NSString *errString = PBFormat(@"请输入%d~%d位验证码！", ME_REGULAR_CODE_LEN_MIN, ME_REGULAR_CODE_LEN_MAX);
        [SVProgressHUD showErrorWithStatus:errString];
        return;
    }
    [pb setCode:code];
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
            [MEKits handleError:err];
        } else {
            NSArray<MEPBUser*>*list = userList.userListArray.copy;
            if (list.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"此账号未关联任何数据，请联系客服！"];
                return ;
            } else if (list.count == 1) {
                MEPBUser *user = list.firstObject;
                [self handleSingleUserSignIn:user];
            } else {
                [self handleMulticastUserIdentitySwitchEvent:userList];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

#pragma mark --- 处理多用户登录身份选择

- (void)handleMulticastUserIdentitySwitchEvent:(MEPBUserList*)list {
    if (list.userListArray.count > 1) {
        [self.view endEditing:true];
        //CGRect fromBounds = CGRectZero;
        CGRect bounds = CGRectMake(0, 0, MESCREEN_WIDTH, MESCREEN_HEIGHT);
        MEMulticastRole *roleScene = [[MEMulticastRole alloc] initWithFrame:bounds users:list.userListArray.copy];
        roleScene.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [self.view addSubview:roleScene];
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            roleScene.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        weakify(self)
        roleScene.callback = ^(MEPBUser * u){
            strongify(self)
            [self resignInUser:u];
        };
        self.multicastRoleScene = roleScene;
    }
}

- (void)resignInUser:(MEPBUser *)user {
    weakify(self)
    [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
        strongify(self)
        self.multicastRoleScene.transform = CGAffineTransformMakeScale(0, 0);
        self.multicastRoleScene.alpha = 0;
    } completion:^(BOOL finished) {
        strongify(self)
        [self.multicastRoleScene removeFromSuperview];
        _multicastRoleScene = nil;
    }];
    //goto signin
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    [pb setLoginName:user.username];
    //apns token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:ME_APPLICATION_APNE_TOKEN];
    [pb setAppleToken:token];
    //device info
    MEPBPhoneInfo *info = [MEUserVM getDeviceInfo];
    pb.phoneInfo = info;
    
    MEUserVM *vm = [MEUserVM vmWithPB:pb];
    vm.sessionToken = user.sessionToken;
    NSData *pbdata = [pb data];
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBUserList *userList = [MEPBUserList parseFromData:resObj error:&err];
        if (err || userList.userListArray.count == 0) {
            [MEKits handleError:err];
        } else {
            MEPBUser *curUser = userList.userListArray.firstObject;
            [self handleSingleUserSignIn:curUser];
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

- (void)handleSingleUserSignIn:(MEPBUser *)user {
    user.signinstamp = [MEKits currentTimeInterval];
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
            [MEKits handleError:err];
        } else {
            MEPBUser *user = userList.userListArray.firstObject;
            user.signinstamp = [MEKits currentTimeInterval];
            [MEUserVM saveUser:user];
            [self.appDelegate updateCurrentSignedInUser:user];
            //登录成功之后的操作
            [self splash2ChangeDisplayStyle:MEDisplayStyleVisitor];
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
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
