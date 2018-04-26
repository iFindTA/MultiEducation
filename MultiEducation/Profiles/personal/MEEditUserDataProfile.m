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

- (void)editTouchEvent {
        int32_t gender = 0;
        if ([_editScene.textfield.text isEqualToString: @"男"]) {
            gender = 1;
            FscUserPb *user = [[FscUserPb alloc] init];
            user.gender = gender;
            MEGenderVM *genderVM = [MEGenderVM vmWithModel: user];
            [self postData: user vm: genderVM];
        } else if ([_editScene.textfield.text isEqualToString: @"女"]) {
            gender = 2;
            FscUserPb *user = [[FscUserPb alloc] init];
            user.gender = gender;
            MEGenderVM *genderVM = [MEGenderVM vmWithModel: user];
            [self postData: user vm: genderVM];
        } else {
            [SVProgressHUD showErrorWithStatus: @"请输入正确的性别"];
        }

//        FscUserPb *user = [[FscUserPb alloc] init];
//        user.name = _editScene.textfield.text;
//        MEUserNameVM *nameVM = [MEUserNameVM vmWithModel: user];
//        [self postData: user vm: nameVM];
}

- (void)postData:(FscUserPb *)user vm:(MEUserEditVM *)vm {
    NSData *data = [user data];
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        
        [self.navigationController popViewControllerAnimated: YES];

    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)createSubViews {
        NSString *placeHolder;
        placeHolder = @"请输入昵称";

        _editScene = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _editScene.textfield.placeholder = placeHolder;
    [_editScene becomeFirstResponder];
        [self.view addSubview: _editScene];
        
//        layout
        [_editScene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
            make.height.mas_equalTo(54.f);
            make.width.mas_equalTo(MESCREEN_WIDTH);
        }];
}

@end
