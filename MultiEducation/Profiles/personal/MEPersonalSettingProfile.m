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

#define TITLE_LIST @[@"头像管理", @"昵称", @"手机号", @"性别"]

static NSString * const USER_ICON_CELL_IDEF = @"user_icon_cell_idef";
static NSString * const USER_DATA_CELL_IDEF = @"user_data_cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEPersonalSettingProfile () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UploadImagesCallBack>

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
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_NAVIGATIONBAR + ME_HEIGHT_STATUSBAR);
    }];
}

- (void)customNavigation {
    NSString *title = @"个人资料";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
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
            [self getAlertToChangePhoto];
        }
            break;
        case 1: {
            //修改昵称
            NSString *urlStr = @"profile://MEEditUserDataProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [self handleTransitionError: error];
        }
            break;
        case 2: {
            //修改手机号
            NSString *urlStr = @"profile://MERephoneProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [self handleTransitionError: error];
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
        //此处更新MEPBUser.currentUser的库字段
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)getAlertToChangePhoto {
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle: @"提示" message: @"请选择上传方式" preferredStyle: UIAlertControllerStyleActionSheet];
    
    weakify(self);
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [self gotoTakePhoto];
    }];
    
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle: @"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [self gotoImagePickerContoller];
    }];
    
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
    
    [aletController addAction: ac1];
    [aletController addAction: ac2];
    [aletController addAction: cancelAC];
    
    [self presentViewController: aletController animated: YES completion: nil];
}

//拍照上传
- (void)gotoTakePhoto {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController: _imagePicker animated:YES completion:nil];
}

//从相册选择
- (void)gotoImagePickerContoller {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController: _imagePicker animated:YES completion:nil];
}

- (void)uploadToQNServe:(UIImage *)image {
    UIImage *compressImage = [self compressImage: image];
    NSString *md5Str = [UIImagePNGRepresentation(compressImage) md5String];
    NSString *key = [NSString stringWithFormat: @"%@.jpg", md5Str];
//    [self.qnUtils uploadWithData: UIImagePNGRepresentation([self compressImage: image]) key: key];
}

- (UIImage *)compressImage:(UIImage *)image {
    float limit = self.currentUser.systemConfigPb.uploadLimit.floatValue;
    float uploadLimit = (limit == 0 ? 2 * 1024 * 1024 : limit * 1024 * 1024);
    NSData *data = UIImageJPEGRepresentation([MEKits compressImage: image toByte: uploadLimit], 0.5);
    UIImage *compressImage = [UIImage imageWithData: data];
    return compressImage;
}

- (void)sendChangeUserHeadToServer:(NSString *)portrait {
    FscUserPb *userPb = [[FscUserPb alloc] init];
    userPb.portrait = portrait;
    NSData *data = [self.currentUser data];

    MEPortraitVM *portraitVM = [MEPortraitVM vmWithModel: userPb];
    
    [portraitVM postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        MEPBUser *user = [MEPBUser parseFromData: resObj error: nil];
        //此处更新MEPBUser.currentUser的库字段
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

#pragma mark - UploadImagesCallback
- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    [self sendChangeUserHeadToServer: key];
}

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    [SVProgressHUD showErrorWithStatus: @"上传头像失败"];
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
                cell.subtitleLab.text = self.currentUser.username;
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    weakify(self);
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
        strongify(self);
        [self uploadToQNServe: image];
    }];
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
        _qnUtils = [[MEQiniuUtils alloc] init];
        _qnUtils.delegate = self;
    }
    return _qnUtils;
}

@end
