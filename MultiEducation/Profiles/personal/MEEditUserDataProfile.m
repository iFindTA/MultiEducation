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
#import "Meuser.pbobjc.h"
#import "MEUserVM.h"
#import "MEGenderVM.h"
#import "MEMobileVM.h"
#import "MEUserNameVM.h"

@interface MEEditUserDataProfile () <UITextFieldDelegate> {
    MEEditType _type;
}

@property (nonatomic, strong) MEEditScene *editScene;

@end

@implementation MEEditUserDataProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (params) {
        _type = [[params objectForKey: @"type"] intValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customNavigation];
    [self createSubViews];

}

- (void)customNavigation {
    NSString *title;
    
    if (_type == MEEditTypeNickName) {
        title = @"编辑昵称";
    } else if (_type == MEEditTypeGender) {
        title = @"编辑性别";
    } else {
        title = @"更换手机号";
    }
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"上传" style: UIBarButtonItemStyleDone target: self action: @selector(editTouchEvent)];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)editTouchEvent {
    if (_type == MEEditTypeGender) {
        int32_t gender = 0;
        if ([_editScene.textfield.text isEqualToString: @"男"]) {
            gender = 1;
            MEPBUser *user = self.currentUser;
            user.gender = gender;
            MEGenderVM *genderVM = [MEGenderVM vmWithModel: user];
            [self postData: user vm: genderVM];
        } else if ([_editScene.textfield.text isEqualToString: @"女"]) {
            gender = 2;
            MEPBUser *user = self.currentUser;
            user.gender = gender;
            MEGenderVM *genderVM = [MEGenderVM vmWithModel: user];
            [self postData: user vm: genderVM];
        } else {
            [SVProgressHUD showErrorWithStatus: @"请输入正确的性别"];
        }
    }

    if (_type == MEEditTypeNickName) {
        MEPBUser *user = self.currentUser;
        user.name = _editScene.textfield.text;
        MEUserNameVM *nameVM = [MEUserNameVM vmWithModel: user];
        [self postData: user vm: nameVM];
    }
}

- (void)postData:(MEPBUser *)user vm:(MEUserEditVM *)vm {
    NSData *data = [user data];
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        
        [self.navigationController popViewControllerAnimated: YES];

    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)createSubViews {
    if (_type == MEEditTypeGender || _type == MEEditTypeNickName) {
        
        NSString *placeHolder;
        if (_type == MEEditTypeNickName) {
            placeHolder = @"请输入昵称";
        } else {
            placeHolder = @"请输入性别";
        }
        
        _editScene = [[NSBundle mainBundle] loadNibNamed: @"MEEditScene" owner: self options: nil].firstObject;
        _editScene.textfield.placeholder = placeHolder;
        [self.view addSubview: _editScene];
        
//        layout
        [_editScene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
            make.height.mas_equalTo(54.f);
            make.width.mas_equalTo(MESCREEN_WIDTH - 33.f);
        }];
    } else {
        
        
        
        
        
        
        
        
    }
}

@end
