//
//  MEPersonalSettingProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPersonalSettingProfile.h"
#import "MEPersonalDataCell.h"
#import "MEHeaderIconCell.h"
#import "MEQiniuUtils.h"
#import <YYKit.h>
#import "Meuser.pbobjc.h"
#import "MEUserVM.h"
#import "MeuserData.pbobjc.h"
#import "MEGenderVM.h"
#import "MEEditUserDataProfile.h"
#import "MEPortraitVM.h"
#import <TZImagePickerController.h>

#define TITLE_LIST @[@"头像管理", @"昵称", @"手机号", @"性别"]

static NSString * const USER_ICON_CELL_IDEF = @"user_icon_cell_idef";
static NSString * const USER_DATA_CELL_IDEF = @"user_data_cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEPersonalSettingProfile () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation MEPersonalSettingProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation];
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
    }];
}

- (void)customNavigation {
    NSString *title = @"个人资料";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)pushToNextProfile:(NSInteger)index {
    switch (index) {
        case 0: {
            //修改头像
            TZImagePickerController *imagePickerPorfile = [[TZImagePickerController alloc] initWithMaxImagesCount: 1 delegate: self];
            [self presentViewController: imagePickerPorfile animated: YES completion: nil];
        }
            break;
        case 1: {
            //修改昵称
            NSString *urlStr = @"profile://MEEditUserDataProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [MEKits handleError: error];
        }
            break;
        case 2: {
            //修改手机号
            NSString *urlStr = @"profile://MERephoneProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [MEKits handleError: error];
        }
            break;
        case 3: {
            //修改性别
            [self getAlertToChangeGender];
        }
            break;
        default:
            break;
    }
}

- (void)getAlertToChangeGender {
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle: @"提示" message: @"请选择性别" preferredStyle: UIAlertControllerStyleActionSheet];
    
    weakify(self);
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle: @"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [self sendGenderToServer: 1];
    }];
    
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle: @"女" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [self sendGenderToServer: 2];
    }];
    
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
    
    [aletController addAction: ac1];
    [aletController addAction: ac2];
    [aletController addAction: cancelAC];
    
    [self presentViewController: aletController animated: YES completion: nil];
}

- (void)sendGenderToServer:(int32_t)gender {
    FscUserPb *userPb = [[FscUserPb alloc] init];
    userPb.gender = gender;
    MEGenderVM *vm = [MEGenderVM vmWithModel: userPb];
    NSData *data = [userPb data];
    weakify(self);
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        MEPBUser *oldUser = self.appDelegate.curUser;
        oldUser.gender = gender;
        [MEUserVM updateUserGender:gender uid:oldUser.uid];
        [self.appDelegate updateCurrentSignedInUser:oldUser];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MEHeaderIconCell *cell = [tableView dequeueReusableCellWithIdentifier: USER_ICON_CELL_IDEF forIndexPath: indexPath];
        cell.textLab.text = [TITLE_LIST objectAtIndex: indexPath.row];
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.currentUser.portrait];
        [cell.headIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
        return cell;
    } else {
        MEPersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier: USER_DATA_CELL_IDEF forIndexPath: indexPath];
        cell.titleLab.text = [TITLE_LIST objectAtIndex: indexPath.row];
        switch (indexPath.row) {
            case 1:
                cell.subtitleLab.text = self.currentUser.name;
                break;
            case 2:
                cell.subtitleLab.text = self.currentUser.mobile;
                break;
            case 3: {
                NSString *gender;
                if (self.currentUser.gender == 1) {
                    gender = @"男";
                } else {
                    gender = @"女";
                }
                cell.subtitleLab.text = gender;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [self pushToNextProfile: indexPath.row];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos[0];
    weakify(self);
    [MEKits handleUploadPhotos: @[image] assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        [self.qnUtils uploadImages: images  callback:^(NSArray *succKeys, NSArray *failKeys, NSError *error) {
            NSString *portrait = succKeys[0];
            FscUserPb *pb = [[FscUserPb alloc] init];
            pb.portrait = portrait;
            MEPortraitVM *vm = [MEPortraitVM vmWithModel:pb];
            [vm postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
                [self updateLocalUser4Portrait:portrait];
            } failure:^(NSError * _Nonnull error) {
                [MEKits handleError: error];
            }];
        }];
    }];
}

- (void)updateLocalUser4Portrait:(NSString *)avatar {
    MEPBUser *oldUser = self.appDelegate.curUser;
    oldUser.portrait = avatar;
    [MEUserVM updateUserAvatar:avatar uid:oldUser.uid];
    [self.appDelegate updateCurrentSignedInUser:oldUser];
    [self.tableView reloadData];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

        [_tableView registerNib: [UINib nibWithNibName: @"MEHeaderIconCell" bundle: nil] forCellReuseIdentifier: USER_ICON_CELL_IDEF];
        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalDataCell" bundle: nil] forCellReuseIdentifier: USER_DATA_CELL_IDEF];
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = TITLE_LIST;
    }
    return _dataArr;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;//是否可编辑
    }
    return _imagePicker;
}

- (MEQiniuUtils *)qnUtils {
    if (!_qnUtils) {
        _qnUtils = [MEQiniuUtils sharedQNUploadUtils];
        //_qnUtils.delegate = self;
    }
    return _qnUtils;
}

@end
