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
#import "MEProgressCell.h"
#import "MEQNUploadVM.h"
#import "Meqnfile.pbobjc.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 60.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource, UploadImagesCallBack> {
    NSInteger _failCount;
}

@property (nonatomic, strong) NSMutableString *fileName;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <MEPhoto *> *totalImages;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *images;   //user choosed images for uploading
@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@property (nonatomic, strong) MEPBQNFile *qnPb;
@property (nonatomic, strong) MEQNUploadVM *qnVM;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _totalImages = [params objectForKey: @"images"];
    }
    return self;
}

- (void)customNavigation {
    NSString *title = @"上传进度";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2" withTarget: self withSelector: @selector(backButtonItemTouchEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)backButtonItemTouchEvent {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    [self.images addObjectsFromArray: _totalImages];
    [self uploadImagesToQNServer];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadImagesToQNServer {
    NSMutableArray *images = [NSMutableArray array];
    for (MEPhoto *photo in self.images) {
        [images addObject: photo.image];
    }
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.qnUtils uploadImages:images atIndex:0 token: [self appDelegate].curUser.uptoken keys: tmpArr];
}

//after upload over send post to server
//if retry = YES , means user did select retry button to upload image
- (void)sendPostToServer:(BOOL)retry key:(NSString *)fileName {
    
    MEQNUploadVM *uploadVM = [MEQNUploadVM vmWithPb: self.qnPb];

    if (retry) {
        self.qnPb.fileMd5Str = fileName;
    } else {
        self.qnPb.fileMd5Str = self.fileName;
    }
    
    NSData *data = [self.qnPb data];
    
    weakify(self);
    [uploadVM postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        
        NSLog(@"success upload total");
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self handleTransitionError:error];
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
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEProgressCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    [cell setData: [_images objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![_images objectAtIndex: indexPath.row].uploadSucc) {
        //only upload fail can select cell to retry
        NSLog(@"did select course of upload fail");
        [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
        [self sendPostToServer: YES key: [_images objectAtIndex: indexPath.row].md5FileName];
    }
}

#pragma mark - UploadImagesCallBack
- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp index:(NSInteger)index {
    [_totalImages objectAtIndex: index].md5FileName = key;
    [_images objectAtIndex: _failCount].md5FileName = key;
    [self.fileName appendString: [NSString stringWithFormat:@"%@,", key]];
    [_images removeObjectAtIndex: _failCount];
    [self.tableView reloadData];
}

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp index:(NSInteger)index {
    [_totalImages objectAtIndex: index].md5FileName = key;
    [_images objectAtIndex: _failCount].md5FileName = key;
    _failCount++;
    [_images objectAtIndex: _failCount - 1].progress = 0;
    [_images objectAtIndex: _failCount - 1].uploadSucc = NO;
    [self.tableView reloadData];
}

- (void)uploadImageProgress:(NSString *)key percent:(float)percent index:(NSInteger)index {
    [_images objectAtIndex: index].progress = percent;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: index inSection:0];
    [self.tableView reloadRowsAtIndexPaths: @[indexpath] withRowAnimation: UITableViewRowAnimationNone];
}

- (void)uploadOver {
    [self sendPostToServer: NO key: nil];
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

- (MEPBQNFile *)qnPb {
    if (!_qnPb) {
        _qnPb = [[MEPBQNFile alloc] init];
    }
    return _qnPb;
}

- (NSMutableArray<MEPhoto *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
