//
//  MEEditUserDataProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
// 

#import "MEEditUserDataProfile.h"
#import "MEEditScene.h"
#import "MEUserEditVM.h"
#import "MeuserData.pbobjc.h"
#import "MEUserVM.h"
#import "MEGenderVM.h"
#import "MEMobileVM.h"
#import "MEUserNameVM.h"

@interface MEEditUserDataProfile () <UITextFieldDelegate>

@property (nonatomic, strong) MEEditScene *editScene;

@end

@implementation MEEditUserDataProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self customNavigation];
    [self createSubViews];
}

- (void)customNavigation {
    NSString *title;
    
    title = @"编辑昵称";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"修改" style: UIBarButtonItemStyleDone target: self action: @selector(editTouchEvent)];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)createSubViews {
    NSString *placeHolder;
    placeHolder = @"请输入昵称";
    
    _editScene = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
    _editScene.textfield.text = self.currentUser.name;
    _editScene.textfield.placeholder = placeHolder;
    [_editScene becomeFirstResponder];
    [self.view addSubview: _editScene];

    [_editScene mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset([MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR);
        make.height.mas_equalTo(54.f);
        make.width.mas_equalTo(MESCREEN_WIDTH);
    }];
}

- (void)editTouchEvent {
    NSString *nick = _editScene.textfield.text;
    if (nick.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称!"];
        return;
    }
    
    FscUserPb *user = [[FscUserPb alloc] init];
    user.name = nick;
    MEUserNameVM *vm = [MEUserNameVM vmWithModel: user];
    NSData *data = [user data];
    weakify(self)
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self)
        [self handleModifyResult4Nick:nick];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)handleModifyResult4Nick:(NSString *)nick {
    if (self.DidUpdateNicknameCallback) {
        self.DidUpdateNicknameCallback();
    }
    MEPBUser *oldUser = self.appDelegate.curUser;
    oldUser.name = nick;
    [MEUserVM updateUserNick:nick uid:oldUser.uid];
    [self.appDelegate updateCurrentSignedInUser:oldUser];
    [self defaultGoBackStack];
}

@end
