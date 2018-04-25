//
//  MEPhotoProgressProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPhotoProgressProfile.h"
#import "MEQiniuUtils.h"
#import "MEProgressCell.h"
#import "MEQNUploadVM.h"
#import "Meqnfile.pbobjc.h"
#import <YYKit.h>
#import "MebabyAlbum.pbobjc.h"
#import "MEFileQuryVM.h"
#import "NSData+UTF8String.h"
#import "MEBabyAlbumListVM.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 60.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource, UploadImagesCallBack> {
    NSMutableArray *_dataArr;
    NSInteger _classId;
    NSInteger _parentId;
}

@property (nonatomic, strong) NSMutableArray *albumArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _dataArr = [NSMutableArray arrayWithArray: [params objectForKey: @"datas"]];
        _classId = [[params objectForKey: @"classId"] integerValue];
        _parentId = [[params objectForKey: @"parentId"] integerValue];
    }
    return self;
}

- (void)customNavigation {
    NSString *title = @"上传进度";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
    
    [self uploadToQNServer];
}

- (void)uploadToQNServer {
    weakify(self);
    [self.qnUtils checkWhetherExistInServer: _dataArr callback:^(NSDictionary *returnDic) {
        strongify(self);
        [_dataArr removeAllObjects];
        
        NSArray <NSDictionary *> *noExistArr = [returnDic objectForKey: @"noExist"];
        NSArray <NSDictionary *> *existArr = [returnDic objectForKey: @"exist"];
        
        NSMutableArray <ClassAlbumPb *> *forUploadArr = [NSMutableArray array];
        for (NSDictionary *dict in noExistArr) {
            ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
            pb.classId = _classId;
            pb.md5 = [dict objectForKey: @"md5"];
            pb.filePath = [dict objectForKey: @"filePath"];
            pb.fileName = [dict objectForKey: @"fileName"];
            pb.fileType = [dict objectForKey: @"extension"];
            pb.fileSize = [[dict objectForKey: @"fileSize"] integerValue];
            pb.upPercent = 0;
            pb.parentId = _parentId;
            pb.isExist = 0;
            pb.uploadStatu = MEUploadStatus_Waiting;
            pb.fileData = [dict objectForKey: @"data"];
            [forUploadArr addObject: pb];
            [_dataArr addObject: pb];
        }
        
        for (NSDictionary *dict in existArr) {
            ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
            pb.classId = _classId;
            pb.md5 = [dict objectForKey: @"md5"];
            pb.filePath = [dict objectForKey: @"filePath"];
            pb.parentId = _parentId;
            pb.fileName = [dict objectForKey: @"fileName"];
            pb.fileType = [dict objectForKey: @"extension"];
            pb.fileSize = [[dict objectForKey: @"fileSize"] integerValue];
            pb.upPercent = 0;
            pb.isExist = 1;
            pb.fileData = [dict objectForKey: @"data"];
            pb.uploadStatu = MEUploadStatus_IsExist;
            [_dataArr addObject: pb];
        }
        [self.tableView reloadData];
        if (forUploadArr.count != 0) {
            [self.qnUtils uploadImagesWithUncheck: forUploadArr];
        } else {
            [SVProgressHUD showErrorWithStatus: @"当前选中的所有照片均已上传过！"];
        }
    }];
}

- (void)sendUploadResultToServer:(ClassAlbumPb *)albumPb {
    MEQNUploadVM *vm = [MEQNUploadVM vmWithPb: albumPb reqCode: REQ_CLASS_ALBUM_FILE_UPLOAD];
    [vm postData: [albumPb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        ClassAlbumPb *albumPb = [ClassAlbumPb parseFromData: resObj error: nil];
        for (ClassAlbumPb *pb in _dataArr) {
            if ([albumPb.filePath isEqualToString: pb.filePath]) {
                albumPb.upPercent = 1;
                albumPb.uploadStatu = MEUploadStatus_Success;
                albumPb.fileId = pb.fileId;
                albumPb.fileType = pb.fileType;
                albumPb.filePath = pb.filePath;
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}


- (void)uploadTotalSuccAlert {
    UIAlertController *alertProfile = [UIAlertController alertControllerWithTitle:@"上传完成！" message:@"是否继续上传？" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *reUploadAc = [UIAlertAction actionWithTitle:@"继续上传" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertProfile setPreferredAction: reUploadAc];
    [alertProfile setPreferredAction: cancelAc];
    
    [self.navigationController presentViewController:alertProfile animated: YES completion: nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_dataArr objectAtIndex: 0] isKindOfClass: [ClassAlbumPb class]]) {
        return _dataArr.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEProgressCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    [cell setData: [_dataArr objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
}

#pragma mark - UploadImagesCallBack
- (void)uploadImageSuccess:(NSString *)key {
    for (ClassAlbumPb *pb in _dataArr) {
        if ([pb.filePath isEqualToString: key]) {
            [self sendUploadResultToServer: pb];
        }
    }
}

- (void)uploadImageFail:(NSString *)key {
    for (ClassAlbumPb *pb in _dataArr) {
        if ([pb.filePath isEqualToString: key]) {
            pb.upPercent = 0;
            pb.uploadStatu = MEUploadStatus_Failure;
            [self.tableView reloadData];
        }
    }
}

- (void)uploadImageProgress:(NSString *)key percent:(float)percent {
    for (ClassAlbumPb *pb in _dataArr) {
        if ([pb.filePath isEqualToString: key]) {
            pb.upPercent = percent;
            pb.uploadStatu = MEUploadStatus_Uploading;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerNib: [UINib nibWithNibName: @"MEProgressCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

- (MEQiniuUtils *)qnUtils {
    if (!_qnUtils) {
        _qnUtils = [MEQiniuUtils sharedQNUploadUtils];
        _qnUtils.delegate = self;
    }
    return _qnUtils;
}

- (NSMutableArray *)albumArr {
    if (!_albumArr) {
        _albumArr = [NSMutableArray array];
    }
    return _albumArr;
}

@end
