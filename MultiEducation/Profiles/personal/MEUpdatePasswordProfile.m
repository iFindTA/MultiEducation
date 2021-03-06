#import "MEUpdatePasswordProfile.h"
#import "MEEditScene.h"
#import "MesignIn.pbobjc.h"
#import "MERePasswordVM.h"
#import "MEMobileVM.h"
#import "MeuserData.pbobjc.h"
#import "MEVerifyCodeVM.h"
#import <YYKit.h>

#define MAX_WAIT_TIME 60

static CGFloat const ROW_HEIGHT = 54.f;

@interface MEUpdatePasswordProfile () {
    NSInteger _count;
    BOOL _isTimerRun;   //是否处于读秒时间
}

@property (nonatomic, strong) MEEditScene *phone;
@property (nonatomic, strong) MEEditScene *code;
@property (nonatomic, strong) MEEditScene *pwd;
@property (nonatomic, strong) MEBaseButton *getCodeBtn;
@property (nonatomic, strong) MEBaseButton *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MEUpdatePasswordProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = MAX_WAIT_TIME;
    
    [self customNavigation];
    
    [self.view addSubview: self.phone];
    [self.view addSubview: self.code];
    [self.view addSubview: self.getCodeBtn];
    [self.view addSubview: self.pwd];
    [self.view addSubview: self.confirmBtn];
    
    //layout
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ROW_HEIGHT);
        make.top.mas_equalTo(self.view.mas_top).mas_offset([MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR);
    }];
    
    [self.pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ROW_HEIGHT);
        make.top.mas_equalTo(self.code.mas_bottom).mas_offset(5.f);
    }];
    
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ROW_HEIGHT);
        make.top.mas_equalTo(self.phone.mas_bottom).mas_offset(5.f);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20.f);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.code);
    }];
    
    [self.getCodeBtn layoutIfNeeded];
    _getCodeBtn.layer.cornerRadius = self.getCodeBtn.frame.size.height / 2;
    _getCodeBtn.layer.masksToBounds = true;
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(30.f);
        make.right.mas_equalTo(self.view).mas_offset(-30.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.pwd.mas_bottom).mas_offset(30.f);
    }];
    
    [self.confirmBtn layoutIfNeeded];
    self.confirmBtn.layer.cornerRadius = 4.f;
    self.confirmBtn.layer.masksToBounds = true;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)customNavigation {
    NSString *title = @"修改密码";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)timerStart {
    _isTimerRun = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.f target: self selector: @selector(timerRun) userInfo: nil repeats: YES];
    [_timer setFireDate: [NSDate date]];
}

- (void)timerRun {
    if (_count <= 1) {
        _count = MAX_WAIT_TIME;
        [self.getCodeBtn setTitle: @"验证码" forState: UIControlStateNormal];
        [self timerEnd];
    } else {
        _count--;
        [self.getCodeBtn setTitle: [NSString stringWithFormat: @"%ld秒", _count] forState: UIControlStateNormal];
    }
}

- (void)timerEnd {
    _isTimerRun = NO;
    [_timer invalidate];
    _timer = nil;
}

- (void)confirmButtonTouchEvent {
    //FIXME: CHECK TYPE
    if (_pwd.textfield.text.length < 6 || _pwd.textfield.text.length > 12) {
        [SVProgressHUD showErrorWithStatus: @"请输入6-12位的密码"];
        return;
    }
    
    if (_code.textfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus: @"请输入验证码"];
        return;
    }
    
    FscUserPb *userPb = [[FscUserPb alloc] init];
    userPb.code = _code.textfield.text;
    userPb.password = [_pwd.textfield.text md5String];
    MERePasswordVM *vm = [MERePasswordVM vmWithModel: userPb];
    
    NSData *data = [userPb data];
    
    weakify(self);
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        [self makeToast: @"密码已修改，请重新登录"];
        [self performSelector: @selector(logout) withObject: nil afterDelay: 1.f];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
    

}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool: YES] forKey: ME_USER_DID_INITIATIVE_LOGOUT];
    [self.appDelegate updateCurrentSignedInUser:nil];
    [self splash2ChangeDisplayStyle: MEDisplayStyleAuthor];
}

- (void)sendSignInVerifyCodeEvent {
    if (_isTimerRun) {
        return;
    }
    //check mobile
    NSString *mobile = self.phone.textfield.text;
    if (![mobile pb_isMatchRegexPattern:ME_REGULAR_MOBILE]) {
        [self makeToast:@"请输入正确的手机号码！"];
        return;
    }
    //assemble pb file
    MEPBSignIn *pb = [[MEPBSignIn alloc] init];
    [pb setLoginName:mobile];
    //goto signin
    MEVerifyCodeVM *vm = [MEVerifyCodeVM vmWithPB:pb];
    NSData *pbdata = [pb data];
    weakify(self)
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        //strongify(self)
        [SVProgressHUD showSuccessWithStatus:@"发送验证码成功！"];
        [self timerStart];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lazyloading
- (MEEditScene *)phone {
    if (!_phone) {
        _phone = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        self.phone.textfield.userInteractionEnabled = false;
        _phone.textfield.placeholder = @"请输入手机号";
        [_phone becomeFirstResponder];
        _phone.textfield.text = self.currentUser.mobile;
    }
    return _phone;
}

- (MEEditScene *)code {
    if (!_code) {
        _code = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _code.textfield.placeholder = @"请输入验证码";
    }
    return _code;
}

- (MEEditScene *)pwd {
    if (!_pwd) {
        _pwd = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _pwd.textfield.secureTextEntry = true;
        _pwd.textfield.placeholder = @"请输入密码";
    }
    return _pwd;
}

- (MEBaseButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [[MEBaseButton alloc] init];
        [_getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor: UIColorFromRGB(ME_THEME_COLOR_TEXT) forState:UIControlStateNormal];
        _getCodeBtn.layer.borderWidth = ME_LAYOUT_LINE_HEIGHT;
        _getCodeBtn.layer.borderColor = UIColorFromRGB(ME_THEME_COLOR_TEXT).CGColor;
        _getCodeBtn.backgroundColor = [UIColor whiteColor];
        [_getCodeBtn addTarget: self action: @selector(sendSignInVerifyCodeEvent) forControlEvents: UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
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




