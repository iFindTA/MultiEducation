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
#import <YYKit.h>
#import "MEVideo.h"
#import "MebabyAlbum.pbobjc.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 60.f;

@interface MEPhotoProgressProfile () <UITableViewDelegate, UITableViewDataSource, UploadImagesCallBack> {
    BOOL _isUploadOver; //本次上传是否结束
    BOOL _isSetMd5FileName;
    
    MEUploadType _type;
    NSInteger _classId;
}

@property (nonatomic, strong) NSMutableString *fileName;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <MEPhoto *> *totalImages;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *images;   //user choosed images for uploading

@property (nonatomic, strong) NSArray <MEVideo *> *totalVideo;
@property (nonatomic, strong) NSMutableArray <MEVideo *> *videos;    //upload video only can select one!

@property (nonatomic, strong) MEQiniuUtils *qnUtils;

@property (nonatomic, strong) MEPBQNFile *qnPb;
@property (nonatomic, strong) MEQNUploadVM *qnVM;

@property (nonatomic, strong) NSMutableArray *statusArr;

@property (nonatomic, strong) ClassAlbumListPb *albumListPb;

@end

@implementation MEPhotoProgressProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _type = [[params objectForKey: @"type"] integerValue];
        _totalImages = [params objectForKey: @"images"];
        if ([params objectForKey: @"video"]) {
            _totalVideo = [NSArray arrayWithObject: [params objectForKey: @"video"]];
            _videos = [NSMutableArray array];
            [_videos addObject: [params objectForKey: @"video"]];
        }
        _classId = [[params objectForKey: @"classId"] integerValue];
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
    
    _isUploadOver = YES;
    
    [self customNavigation];
    
    if (_type == MEUploadTypeImage) {
        [self.images addObjectsFromArray: _totalImages];
        [self uploadImagesToQNServer: self.images];
    } else {
        [self uploadVideo];
    }
    
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

- (void)uploadVideo {
    if (!_isUploadOver) {
        //if the last uplaod is continue, can't upload this time
        return;
    }
    _isUploadOver = NO;
    
    [self.qnUtils uploadVideo: self.videos[0].video key: [NSString stringWithFormat: @"%@.mp4", self.videos[0].md5FileName]];
    
}

- (void)uploadImagesToQNServer:(NSArray *)imageArr {
    if (!_isUploadOver) {
        //if the last uplaod is continue, can't upload this time
        return;
    }
    _isUploadOver = NO;
    
    NSMutableArray *images = [NSMutableArray array];
    if (!_isSetMd5FileName) {
        for (MEPhoto *photo in imageArr) {
            photo.md5FileName = [NSString stringWithFormat: @"%@.jpg", [self md5StringToImage: photo.image]];
            photo.image = [self compressImage: photo.image];
        }
        _isSetMd5FileName = YES;
    }
    
    for (MEPhoto *photo in imageArr) {
        photo.status = Uploading;
    }

    [images addObjectsFromArray: imageArr];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.qnUtils uploadImages:images keys: tmpArr];
}

- (NSString *)md5StringToImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation([self compressImage: image]);
    NSString *fileName = [data md5String];
    return fileName;
}

- (UIImage *)compressImage:(UIImage *)image {
    float limit = self.currentUser.systemConfigPb.uploadLimit.floatValue;
    float uploadLimit = (limit == 0 ? 2 * 1024 * 1024 : limit * 1024 * 1024);
    NSData *data = UIImageJPEGRepresentation([MEKits compressImage: image toByte: uploadLimit], 0.5);
    UIImage *compressImage = [UIImage imageWithData: data];
    return compressImage;
}

//after upload over send post to server
//if retry = YES , means user did select retry button to upload image
- (void)sendPostToServer:(NSArray *)keys {
    
    NSMutableArray <ClassAlbumPb *> *albumList = [NSMutableArray array];
    for (int i = 0; i < keys.count; i++) {
        ClassAlbumPb *albumPb = [[ClassAlbumPb alloc] init];
        
        if (_type == MEUploadTypeImage) {
            albumPb.fileType = @"jpg";
            albumPb.fileSize = [self.totalImages objectAtIndex: i].fileSize;
        } else {
            albumPb.fileType = @"mp4";
            albumPb.fileSize = self.totalVideo[0].video.length;
        }
        
        albumPb.classId = _classId;
        albumPb.isParent = 0;
        albumPb.parentId = 0;
        albumPb.fileName = [keys objectAtIndex: i];
        albumPb.filePath = [NSString stringWithFormat: @"%@", albumPb.fileName];

        [albumList addObject: albumPb];
    }
    self.albumListPb.classAlbumArray = [NSMutableArray arrayWithArray: albumList];
    MEQNUploadVM *uploadVM = [MEQNUploadVM vmWithPb: self.albumListPb];
    
    NSData *data = [self.albumListPb data];
    
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
    if (_type == MEUploadTypeImage) {
        return self.images.count;
    } else {
        return self.videos.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEProgressCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    if (_type == MEUploadTypeImage) {
        [cell setImageData: [self.images objectAtIndex: indexPath.row]];
    } else {
        [cell setVideoData: [self.videos objectAtIndex: indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
    if (_type == MEUploadTypeImage) {
        if ([_images objectAtIndex: indexPath.row].status == UploadFail) {
            //only upload fail can select cell to retry
            NSLog(@"did select course of upload fail");
            
            [self uploadImagesToQNServer: @[_images[indexPath.row]]];
        }
    } else {
        if (_isUploadOver) {
            [self uploadVideo];
        }
    }
    
}

#pragma mark - UploadImagesCallBack
- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    if (_type == MEUploadTypeImage) {
        MEPhoto *succPhoto;
        for (MEPhoto *photo in _images) {
            if ([photo.md5FileName isEqualToString: key]) {
                photo.status = UploadSucc;
                photo.progress = 1;
                succPhoto = photo;
                break;
            }
        }
        
        [_images removeObject: succPhoto];
    } else  {
        _isUploadOver = YES;
        [_videos removeAllObjects];
        [self sendPostToServer: @[key]];
    }
    [self.tableView reloadData];
}

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    if (_type == MEUploadTypeImage) {
        for (MEPhoto *photo in _images) {
            if ([photo.md5FileName isEqual: key]) {
                photo.progress = 0;
                photo.status = UploadFail;
                break;
            }
        }
    } else {
        for (MEVideo *video in _videos) {
            _isUploadOver = YES;
            video.progress = 0;
            video.status = UploadFail;
        }
    }
    [self.tableView reloadData];
}

- (void)uploadImageProgress:(NSString *)key percent:(float)percent {
    NSLog(@"percent === %.2f", percent);
    if (_type == MEUploadTypeImage) {
        for (MEPhoto *photo in _images) {
            if ([photo.md5FileName isEqualToString: key]) {
                photo.progress = percent;
            }
        }
    } else {
        _videos[0].progress = percent;
    }
    
    [self.tableView reloadData];
}

- (void)uploadOver:(NSArray *)keys {
    _isUploadOver = YES;
    if (keys.count != 0) {
        [self sendPostToServer: keys];
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

- (NSMutableString *)fileName {
    if (!_fileName) {
        _fileName = [NSMutableString string];
    }
    return _fileName;
}

- (NSMutableArray *)statusArr {
    if (!_statusArr) {
        _statusArr = [NSMutableArray array];
        for (int i = 0; i < self.totalImages.count; i++) {
            [_statusArr addObject: [NSNumber numberWithBool: NO]];
        }
    }
    return _statusArr;
}

- (ClassAlbumListPb *)albumListPb {
    if (!_albumListPb) {
        _albumListPb = [[ClassAlbumListPb alloc] init];
    }
    return _albumListPb;
}

@end
