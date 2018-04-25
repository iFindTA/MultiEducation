//
//  MEUserIdentitySwitchProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import "MEUserIdentitySwitchProfile.h"

@interface MEUserIdentitySwitchProfile ()

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) BEMCheckBoxGroup *checkGroup;

@end

@implementation MEUserIdentitySwitchProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
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
    label.text = @"选择用户角色";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(adoptValue(ME_LAYOUT_SUBBAR_HEIGHT * 2));
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    
    MEPBUserList *userList = self.params[@"userList"];
    NSArray<MEPBUser*> *list = userList.userListArray;
    self.checkGroup = [[BEMCheckBoxGroup alloc] init];
    self.checkGroup.mustHaveSelection = true;
    NSUInteger itemSize = ME_LAYOUT_ICON_HEIGHT;
    __block BEMCheckBox *lastBox = nil;UIFont *font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    [list enumerateObjectsUsingBlock:^(MEPBUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BEMCheckBox *box = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        box.onAnimationType = BEMAnimationTypeStroke;
        box.offAnimationType = BEMAnimationTypeFade;
        [self.view addSubview:box];
        [self.checkGroup addCheckBoxToGroup:box];
        [box makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastBox==nil)?label.mas_bottom:lastBox.mas_bottom).offset((lastBox==nil)?ME_LAYOUT_BOUNDARY:ME_LAYOUT_MARGIN*3);
            make.left.equalTo(label);
            make.size.equalTo(CGSizeMake(itemSize, itemSize));
        }];
        box.tag = idx;
        box.on = (idx == 0);
        MEBaseScene *infoScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        infoScene.tag = idx;
        //infoScene.backgroundColor = [UIColor pb_randomColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identitySwitchEvent:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [infoScene addGestureRecognizer:tapGesture];
        [self.view addSubview:infoScene];
        [infoScene makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(box.mas_centerY);
            make.left.equalTo(box.mas_right).offset(ME_LAYOUT_MARGIN);
            make.right.equalTo(self.view);
            make.height.equalTo(itemSize * 1.5);
        }];
        MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        label.font = font;
        label.textColor = fontColor;
        label.text = obj.schoolName.copy;
        [infoScene addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(infoScene);
            make.height.equalTo(infoScene.mas_height).multipliedBy(0.5);
        }];
        MEBaseLabel *subLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        subLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-1);
        subLabel.textColor = fontColor;
        subLabel.text = [self convertType2String:obj];
        [infoScene addSubview:subLabel];
        [subLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(infoScene);
            make.height.equalTo(infoScene.mas_height).multipliedBy(0.5);
        }];
        lastBox = box;
    }];
    //ensure event
    font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ensureIdentityTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastBox.mas_bottom).offset(ME_LAYOUT_BOUNDARY * 2);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
}

/**
 用户类型(1老师;2学生;3家长;4教务)
 */
- (NSString *)convertType2String:(MEPBUser *)usr {
    
    NSUInteger type = usr.userType;
    NSString *str = @"家长";
    if (type == 1) {
        str = @"老师";
    } else if (type == 2) {
        str = @"学生";
    } else if (type == 3) {
        str = @"家长";
    } else if (type == 4) {
        str = @"教务";
    }
    
    return PBFormat(@"%@---%@", str, usr.name);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

- (void)identitySwitchEvent:(UITapGestureRecognizer *)tap {
    UIView *infoScene = [tap view];
    NSArray <BEMCheckBox*>*boxs = [[self.checkGroup checkBoxes] allObjects];
    boxs[infoScene.tag].on = true;
}

- (void)ensureIdentityTouchEvent {
    BEMCheckBox *box = self.checkGroup.selectedCheckBox;
    NSUInteger __tag = box.tag;
    MEPBUserList *userList = self.params[@"userList"];
    NSArray<MEPBUser*> *list = userList.userListArray;
    MEPBUser *user = list[__tag];
    
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
    weakify(self)
    [vm postData:pbdata hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBUserList *userList = [MEPBUserList parseFromData:resObj error:&err];
        if (err || userList.userListArray.count == 0) {
            [self handleTransitionError:err];
        } else {
            MEPBUser *curUser = userList.userListArray.firstObject;
            user.signinstamp = [MEKits currentTimeInterval];
            [MEUserVM saveUser:curUser];
            [self.appDelegate updateCurrentSignedInUser:curUser];
            //登录成功之后的操作
            //有 block 则先执行
            void(^signInCallback)(void) = [self.params objectForKey:ME_DISPATCH_KEY_CALLBACK];
            if (signInCallback) {
                signInCallback();
            }
            BOOL shouldGoback = [self.params pb_boolForKey:ME_SIGNIN_SHOULD_GOBACKSTACK_AFTER_SIGNIN];
            if (shouldGoback) {
                [self backStackBeforeClass:NSClassFromString(@"MESignInProfile")];
            } else {
                [self splash2ChangeDisplayStyle:MEDisplayStyleMainSence];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
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
