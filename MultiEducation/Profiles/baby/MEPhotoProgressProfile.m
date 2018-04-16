//
//  MEPhotoProgressProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPhotoProgressProfile.h"
#import <QiniuSDK.h>

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 44.f;

static double const MAX_IMAGE_LENGTH = 2 * 1024 * 1024; //压缩图片 <= 2MB

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *images;   //user choosed images for uploading
@property (nonatomic, strong) QNUploadManager *qnManager;

@end

@implementation MEPhotoProgressProfile

- (instancetype)initWithImages:(NSArray *)images {
    if (self = [super init]) {
        self.images = [NSMutableArray arrayWithArray: images];
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

-(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys{
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImagePNGRepresentation([MEKits compressImage: image toByte: MAX_IMAGE_LENGTH]);
    NSTimeInterval time= [[NSDate new] timeIntervalSince1970];
    NSString *filename = [NSString stringWithFormat:@"%@_%ld_%.f.%@",@"status",686734963504054272,time,@"jpg"];
    [uploadManager putData:data key:filename token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.isOK) {
                          [keys addObject:key];
                          NSLog(@"idInex %ld,OK",index);
                          imageIndex++;
                          if (imageIndex >= images.count) {
                              NSLog(@"上传完成");
                              for (NSString *imgKey in keys) {
                                  NSLog(@"%@",imgKey);
                              }
                              return ;
                          }
                          [self uploadImages:images atIndex:imageIndex token:token uploadManager:uploadManager keys:keys];
                      }
                      
                  } option:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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

- (QNUploadManager *)qnManager {
    if (!_qnManager) {
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//            builder.zone = [QNFixedZone zoneNa0];
//            builder.useHttps = YES;
        }];
        _qnManager = [QNUploadManager sharedInstanceWithConfiguration: config];
    }
    return _qnManager;
}

@end
