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

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 60.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource, UploadImagesCallBack> {
    NSArray <NSDictionary *> *_dataArr;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _dataArr = [params objectForKey: @"datas"];
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
}

- (void)checkWhereExistInServer {
    
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

@end
