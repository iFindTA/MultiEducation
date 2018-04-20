//
//  MEBabyPhotoProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoProfile.h"
#import "MEBabyPhotoHeader.h"
#import <MWPhotoBrowser.h>
#import "MEPhoto.h"
#import <Photos/Photos.h>
#import "MEBabyAlbumListVM.h"
#import "Meclass.pbobjc.h"
#import "MebabyAlbum.pbobjc.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import <YYKit.h>
#import "MEPhotoProgressProfile.h"
#import "MEVideo.h"
#import "MEBabyContentPhotoCell.h"
#import "METimeLineSectionView.h"

#define TITLES @[@"照片", @"时间轴"]

#define PHOTO_IDEF @"photo_cell_idef"
#define TIME_LINE_IDEF @"time_line_cell_idef"
#define TIME_LINE_SECTION_HEADER_IDEF @"time_line_section_header_idef"

#define PHOTO_CELL_SIZE CGSizeMake((MESCREEN_WIDTH - ITEM_LEADING * 2 - PHOTO_MIN_ITEM_HEIGHT_AND_WIDTH) / 2, (MESCREEN_WIDTH - ITEM_LEADING * 2 - PHOTO_MIN_ITEM_HEIGHT_AND_WIDTH) / 2)
#define TIME_LINE_CELL_SIZE CGSizeMake((MESCREEN_WIDTH - ITEM_LEADING * 2 - TIME_LINE_MIN_ITEM_HEIGHT_AND_WIDTH * 3) / 4, (MESCREEN_WIDTH - ITEM_LEADING * 2 - TIME_LINE_MIN_ITEM_HEIGHT_AND_WIDTH * 3) / 4)


static CGFloat const HEADER_HEIGHT = 60.f;
static CGFloat const PHOTO_MIN_ITEM_HEIGHT_AND_WIDTH = 7.f;
static CGFloat const TIME_LINE_MIN_ITEM_HEIGHT_AND_WIDTH = 1.f;
static CGFloat const ITEM_LEADING = 10.f;

@interface MEBabyPhotoProfile () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MWPhotoBrowserDelegate, TZImagePickerControllerDelegate> {
    NSInteger _classId;
    NSInteger _parendId;
    
    BOOL _isSelectPhotoView;    // YES == 点击照片页面图片   NO == 时间轴
}

@property (nonatomic, strong) MEBabyPhotoHeader *header;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEBaseScene *scrollContent;

@property (nonatomic, strong) UICollectionView *photoView;  //photo
@property (nonatomic, strong) NSArray <MEPhoto *> *totalPhotos;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *photos;   //photo's dataArr

@property (nonatomic, strong) UICollectionView *timeLineView;   //时间轴
@property (nonatomic, strong) NSMutableArray *timeLineArr;  //timeline's dataArr

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSArray <ClassAlbumPb *> *classAlbums;

@property (nonatomic, strong) TZImagePickerController *pickerProfile;

@end

@implementation MEBabyPhotoProfile

- (instancetype)__initWithParmas:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _classId = [[params objectForKey: @"classId"] integerValue];

        if ([params objectForKey: @"photos"]) {
            self.totalPhotos = [params objectForKey: @"photos"];
            [self sortPhotosWithFileParent];
            [self sortPhotoWithTimeLine];
        }
        
        if ([params objectForKey: @"parentId"]) {
            _parendId = [[params objectForKey: @"parentId"] integerValue];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sj_fadeAreaViews = @[self.scrollView];
    
    if (self.photos.count == 0) {
        [self loadDataSource];
    }
    
    [self customNavigation];
    
    [self layoutView];
}

- (void)loadDataSource {
    ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
    MEBabyAlbumListVM *babyVm = [MEBabyAlbumListVM vmWithPb: pb];

    pb.classId = _classId;
    
    NSData *data = [pb data];
    
    weakify(self);
    [babyVm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        ClassAlbumListPb *albumListPb = [ClassAlbumListPb parseFromData: resObj error: nil];
        self.classAlbums = albumListPb.classAlbumArray;

        NSString *urlHead = self.currentUser.bucketDomain;
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (ClassAlbumPb *pb in albumListPb.classAlbumArray) {
            MEPhoto *photo = [[MEPhoto alloc] init];
            photo.urlStr = [NSString stringWithFormat: @"%@/%@", urlHead, pb.filePath];
            MWPhoto *mwPhoto;
            if ([photo.albumPb.fileType isEqualToString: @"jpg"]) {
                mwPhoto = [MWPhoto photoWithURL: [NSURL URLWithString: photo.urlStr]];
            } else {
                mwPhoto = [MWPhoto videoWithURL: [NSURL URLWithString: photo.urlStr]];
            }
            photo.dateStr = [self timeStampToDateString: pb.modifiedDate];
            photo.photo = mwPhoto;
            photo.albumPb = pb;
            [tmpArr addObject: photo];
        }
        
        self.totalPhotos = [NSArray arrayWithArray: tmpArr];
        [self sortPhotosWithFileParent];
        [self sortPhotoWithTimeLine];
        
        [self setVideoCoverImage];
        [self.photoView reloadData];

    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)setVideoCoverImage {
    NSInteger index = 0;
    for (MEPhoto *photo in self.photos) {
        if ([photo.albumPb.fileType isEqualToString: @"mp4"]) {
            dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat: @"get_video_cover_image_%ld", index] UTF8String],  NULL);
            dispatch_async(queue, ^{
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: [NSURL URLWithString: photo.urlStr] options:nil];
                NSParameterAssert(asset);
                AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
                assetImageGenerator.appliesPreferredTrackTransform = YES;
                assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
                CGImageRef thumbnailImageRef = NULL;
                CFTimeInterval thumbnailImageTime = 0.1;
                NSError *thumbnailImageGenerationError = nil;
                thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
                UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
                photo.image = thumbnailImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photoView reloadItemsAtIndexPaths: @[[NSIndexPath indexPathForItem: index inSection: 0]]];
                });
            });
        }
        index++;
    }
}

- (void)sortPhotosWithFileParent {
    for (int i = 0; i < self.totalPhotos.count; i++) {
        MEPhoto *photo = [self.totalPhotos objectAtIndex: i];
        if (photo.albumPb.parentId == _parendId) {
            [self.photos addObject: photo];
        }
    }
}

- (void)sortPhotoWithTimeLine {

    NSMutableArray *dateArr = [NSMutableArray array];
    for (MEPhoto *photo in self.photos) {
        [dateArr addObject: photo.dateStr];
    }
    
    //去重
    NSSet *set = [NSSet setWithArray: dateArr];
    [dateArr removeAllObjects];
    [dateArr addObjectsFromArray: [set allObjects]];
    
    //按日期升序排列
    [dateArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSDate *date1 = [formatter dateFromString:obj1];
        NSDate *date2 = [formatter dateFromString:obj2];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    
    for (int i = 0; i < dateArr.count; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject: dateArr[i] forKey: @"date"];

        NSMutableArray *tmpArr = [NSMutableArray array];
        for (MEPhoto *photo in self.photos) {
            if ([photo.dateStr isEqualToString: dateArr[i]]) {
                [tmpArr addObject: photo];
            }
        }
        [dic setObject: tmpArr forKey: @"photos"];
        
        [self.timeLineArr addObject: dic];
    }
    [self.timeLineView reloadData];
}


- (NSString *)timeStampToDateString:(uint64_t)stamp {
    NSTimeInterval time = stamp / 1000+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *date = [dateFormatter stringFromDate: detaildate];
    return date;
}

- (void)customNavigation {
    NSString *title = @"宝宝相册";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"上传" style: UIBarButtonItemStyleDone target: self action: @selector(uploadTouchEvent)];
    }
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)uploadTouchEvent {
    [self.navigationController presentViewController: self.pickerProfile animated: YES completion: nil];
}

- (void)layoutView {
    [self.view addSubview: self.header];
    [self.view addSubview: self.scrollView];
    [self.scrollView addSubview: self.scrollContent];
    
    [self.scrollContent addSubview: self.photoView];
    [self.scrollContent addSubview: self.timeLineView];
    
    //layout
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
        make.height.mas_equalTo(HEADER_HEIGHT);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.header.mas_bottom);
    }];

    [self.scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
        make.width.greaterThanOrEqualTo(@0.f);
    }];
    
    CGFloat height = MESCREEN_HEIGHT - ME_HEIGHT_NAVIGATIONBAR - ME_HEIGHT_STATUSBAR - HEADER_HEIGHT;
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollContent);
        make.left.mas_equalTo(ITEM_LEADING);
        make.width.mas_equalTo(MESCREEN_WIDTH - 2 * ITEM_LEADING);
        make.height.mas_equalTo(height);
    }];

    [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollContent);
    make.left.mas_equalTo(self.photoView.mas_right).mas_offset(ITEM_LEADING * 2);
        make.width.mas_equalTo(MESCREEN_WIDTH - 2 * ITEM_LEADING);
        make.height.mas_equalTo(height);
    }];
    
    [self.scrollContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2 * MESCREEN_WIDTH);
    }];
}

- (void)pushToUploadProgressProfile:(NSDictionary *)params {
    NSString *urlString = @"profile://root@MEPhotoProgressProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [self handleTransitionError:err];
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

- (NSArray *)getFilePhotosFromParentId:(NSInteger)parentId {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (MEPhoto *photo in self.photos) {
        if (photo.albumPb.parentId == parentId) {
            [tmpArr addObject: photo];
        }
    }
    return tmpArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
        return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (_isSelectPhotoView) {
        return [self.photos objectAtIndex: index].photo;
    } else {
        return [self.photos objectAtIndex: index].photo;
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < photos.count; i++) {
        MEPhoto *photo = [[MEPhoto alloc] init];
        MWPhoto *mwPhoto = [[MWPhoto alloc] initWithImage: [photos objectAtIndex: i]];
        photo.image = [photos objectAtIndex: i];
        photo.md5FileName = [self md5StringToImage: [self compressImage: photo.image]];
        photo.photo = mwPhoto;
        photo.status = Uploading;
        photo.fileSize = UIImageJPEGRepresentation([self compressImage: photo.image], 1).length;

        [images addObject: photo];
    }
    
    NSDictionary *params = @{@"images": images, @"type": [NSNumber numberWithInteger: MEUploadTypeImage], @"classId": [NSNumber numberWithInteger: _classId]};
    [self pushToUploadProgressProfile: params];
    
    
    NSLog(@"photo");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);

        NSData *data = [NSData dataWithContentsOfFile: outputPath];
        
        MEVideo *video = [[MEVideo alloc] init];
        video.image = coverImage;
        video.md5FileName = [data md5String];
        video.video = data;
        video.status = Uploading;
        video.progress = 0;
        
        NSDictionary *params = @{@"video": video, @"type": [NSNumber numberWithInteger: MEUploadTypeVideo], @"classId": [NSNumber numberWithInteger: _classId]};
        [self pushToUploadProgressProfile: params];

    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([collectionView isEqual: self.photoView]) {
        return 1;
    } else {
        return self.timeLineArr.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual: self.photoView]) {
        return self.photos.count;
    } else {
        NSDictionary *dic = [self.timeLineArr objectAtIndex: section];
        NSArray *arr = [dic objectForKey: @"photos"];
        return arr.count;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MEBabyContentPhotoCell *cell;
    if ([collectionView isEqual: self.photoView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: PHOTO_IDEF forIndexPath: indexPath];
        [cell setData: [self.photos objectAtIndex: indexPath.row]];
        return cell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: TIME_LINE_IDEF forIndexPath: indexPath];
        NSDictionary *dic = [self.timeLineArr objectAtIndex: indexPath.section];
        NSArray *arr = [dic objectForKey: @"photos"];
        MEPhoto *photo = [arr objectAtIndex: indexPath.item];
        [cell setData: photo];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.photoView]) {
        return PHOTO_CELL_SIZE;
    } else {
        return TIME_LINE_CELL_SIZE;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        METimeLineSectionView *reusableView;
        if (kind == UICollectionElementKindSectionHeader) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: TIME_LINE_SECTION_HEADER_IDEF forIndexPath: indexPath];
            reusableView.label.text = [(NSDictionary *)[self.timeLineArr objectAtIndex: indexPath.section] objectForKey: @"date"];
        }
        return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _timeLineView) {
        return CGSizeMake(MESCREEN_HEIGHT - 20, 40);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.photoView) {
        if ([self.photos objectAtIndex: indexPath.item].albumPb.isParent) {
            _isSelectPhotoView = YES;
            NSNumber *parentId = [NSNumber numberWithInteger: [self.photos objectAtIndex: indexPath.item].albumPb.id_p];
            NSDictionary *params = @{@"classId": [NSNumber numberWithInteger: _classId], @"photos": [self getFilePhotosFromParentId: parentId.integerValue], @"parentId": parentId};
            NSString *urlString = @"profile://root@MEBabyPhotoProfile/";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
            [self handleTransitionError:err];
            
        } else {
            [self.navigationController pushViewController: self.photoBrowser animated: YES];
            [_photoBrowser setCurrentPhotoIndex: indexPath.item];
            //MWBrowser can't reuser!!! need set nil;
            _photoBrowser = nil;
        }
    } else {
        _isSelectPhotoView = NO;
        MEPhoto *photo = [[(NSDictionary *)[self.timeLineArr objectAtIndex: indexPath.section] objectForKey: @"photos"] objectAtIndex: indexPath.row];
        if (photo.albumPb.isParent) {
            _isSelectPhotoView = YES;
            NSInteger parentId = photo.albumPb.id_p;
            NSDictionary *params = @{@"classId": [NSNumber numberWithInteger: _classId], @"photos": [self getFilePhotosFromParentId: parentId], @"parentId": [NSNumber numberWithInteger: parentId]};
            NSString *urlString = @"profile://root@MEBabyPhotoProfile/";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
            [self handleTransitionError:err];
            
        } else {
            [self.navigationController pushViewController: self.photoBrowser animated: YES];
            [_photoBrowser setCurrentPhotoIndex: indexPath.item];
            //MWBrowser can't reuser!!! need set nil;
            _photoBrowser = nil;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
        [self.header markLineAnimation: page];
    }
}

#pragma mark - lazyloading
- (MEBabyPhotoHeader *)header {
    if (!_header) {
        _header = [[MEBabyPhotoHeader alloc] initWithTitles: TITLES];
        weakify(self);
        _header.babyPhotoHeaderCallBack = ^(NSInteger index) {
            strongify(self);
            [self.scrollView setContentOffset: CGPointMake(index * MESCREEN_WIDTH, 0) animated: YES];
        };
    }
    return _header;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (MEBaseScene *)scrollContent {
    if (!_scrollContent) {
        _scrollContent = [[MEBaseScene alloc] init];
        _scrollContent.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContent;
}

- (UICollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = PHOTO_MIN_ITEM_HEIGHT_AND_WIDTH;
        layout.minimumLineSpacing = PHOTO_MIN_ITEM_HEIGHT_AND_WIDTH;
        
        _photoView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        _photoView.backgroundColor = [UIColor blueColor];
        _photoView.showsVerticalScrollIndicator = NO;
        
        [_photoView registerNib: [UINib nibWithNibName: @"MEBabyContentPhotoCell" bundle: nil] forCellWithReuseIdentifier:  PHOTO_IDEF];
    }
    return _photoView;
}

- (UICollectionView *)timeLineView {
    if (!_timeLineView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = TIME_LINE_MIN_ITEM_HEIGHT_AND_WIDTH;
        layout.minimumLineSpacing = TIME_LINE_MIN_ITEM_HEIGHT_AND_WIDTH;
        layout.headerReferenceSize = CGSizeMake(MESCREEN_HEIGHT - 20, 100);
        
        _timeLineView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _timeLineView.delegate = self;
        _timeLineView.dataSource = self;
        _timeLineView.backgroundColor = [UIColor whiteColor];
        _timeLineView.showsVerticalScrollIndicator = NO;
        
        [_timeLineView registerNib: [UINib nibWithNibName: @"MEBabyContentPhotoCell" bundle: nil] forCellWithReuseIdentifier:  TIME_LINE_IDEF];
        
        [_timeLineView registerClass: [METimeLineSectionView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: TIME_LINE_SECTION_HEADER_IDEF];
        
    }
    return _timeLineView;
}

- (MWPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        //初始化
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        _photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        _photoBrowser.displayNavArrows = NO; //显示左右划动
        _photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        _photoBrowser.alwaysShowControls = NO; //控制条始终显示
        _photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        _photoBrowser.enableGrid = NO;//是否允许网络查看图片
        _photoBrowser.startOnGrid = NO; //是否以网格开始;
        _photoBrowser.enableSwipeToDismiss = YES;
        _photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    }
    return _photoBrowser;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)timeLineArr {
    if (!_timeLineArr) {
        _timeLineArr = [NSMutableArray array];
    }
    return _timeLineArr;
}

- (TZImagePickerController *)pickerProfile {
    if (!_pickerProfile) {
        _pickerProfile = [[TZImagePickerController alloc] initWithMaxImagesCount: 9 delegate: self];
        _pickerProfile.allowPickingOriginalPhoto = NO;
        _pickerProfile.allowPickingVideo = YES;
    }
    return _pickerProfile;
}

@end
