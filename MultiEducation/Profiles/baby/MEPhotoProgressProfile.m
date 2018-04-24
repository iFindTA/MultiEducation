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

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 60.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource, UploadImagesCallBack> {
    NSArray <NSDictionary *> *_dataArr;
    NSInteger _classId;
}
@property (nonatomic, strong) NSMutableArray *albumArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _dataArr = [params objectForKey: @"datas"];
        _classId = [[params objectForKey: @"classId"] integerValue];
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
    
    
//    [self.qnUtils uploadImages: _dataArr callback:^(NSArray *succKeys, NSArray *failKeys) {
//
//        NSLog(@"%", succKeys);
//
//    }];
    
    
    
    [self customNavigation];
    
    [self checkWhereExistInServer];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

//- (void)formatterImageOrVideoToAlbumPb {
//    for (NSDictionary *dic in _dataArr) {
//        ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
//        pb.md5 = [dic objectForKey: @"md5"];
//        pb.fileName = [dic objectForKey: @"fileName"];
//        pb.filePath = [dic objectForKey: @"filePath"];
//        pb.fileType = [dic objectForKey: @"extension"];
//        [self.albumArr addObject: pb];
//    }
//}

- (void)checkWhereExistInServer {
    MEPBQNFile *pb = [[MEPBQNFile alloc] init];
    MEFileQuryVM *fileQuryVM = [MEFileQuryVM vmWithPb: pb];
    
    NSMutableString *md5Str = [NSMutableString string];
    for (NSDictionary *dic in _dataArr) {
        [md5Str appendString: [NSString stringWithFormat: @"%@,", [dic objectForKey: @"md5"]]];
    }
    [md5Str deleteCharactersInRange: NSMakeRange(md5Str.length - 1, 1)];
    pb.fileMd5Str = md5Str;
    weakify(self);
    [fileQuryVM postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        MEPBQNFile *filePb = [MEPBQNFile parseFromData: resObj error: nil];
        
        NSArray *fileIdArr = [filePb.fileIdStr componentsSeparatedByString: @","];
        int index = 0;
        for (NSString *fileId in fileIdArr) {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary: [_dataArr objectAtIndex: index]];
            [tmpDic setObject: @0 forKey: @"progress"];
            [tmpDic setObject: fileId forKey: @"fileId"];
            if (fileId.integerValue <= 0) {
                [self.albumArr addObject: [_dataArr objectAtIndex: index]];
            }
            index++;
        }
        
        [self.qnUtils uploadImages: self.albumArr];
        
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)upLoadToQnServer {
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEProgressCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    
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
- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    
}

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    
}

- (void)uploadImageProgress:(NSString *)key percent:(float)percent {
    
}

- (void)uploadOver:(NSArray *)keys {
    
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
