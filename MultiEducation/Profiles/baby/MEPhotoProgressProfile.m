//
//  MEPhotoProgressProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPhotoProgressProfile.h"
#import "MEQiniuUtils.h"
#import "MEPhoto.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 44.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *images;   //user choosed images for uploading
@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _images = [NSMutableArray arrayWithArray: [params objectForKey: @"images"]];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)upload {
    
    NSMutableArray *images = [NSMutableArray array];
    for (MEPhoto *photo in _images) {
        [images addObject: photo.image];
    }
    
    [self.qnUtils uploadImages:images atIndex:0 token:  uploadManager:<#(QNUploadManager *)#> keys:<#(NSMutableArray *)#>]
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

//- (QNUploadManager *)qnManager {
//    if (!_qnManager) {
//        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
////            builder.zone = [QNFixedZone zoneNa0];
////            builder.useHttps = YES;
//        }];
//        _qnManager = [QNUploadManager sharedInstanceWithConfiguration: config];
//    }
//    return _qnManager;
//}

- (MEQiniuUtils *)qnUtils {
    if (!_qnUtils) {
        _qnUtils = [MEQiniuUtils sharedQNUploadManager];
    }
    return _qnUtils;
}

@end
