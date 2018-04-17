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
#import "MEPhotoSelectProfile.h"
#import "MEPhoto.h"
#import <Photos/Photos.h>

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

@interface MEBabyPhotoProfile () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) MEBabyPhotoHeader *header;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEBaseScene *scrollContent;

@property (nonatomic, strong) UICollectionView *photoView;  //photo
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *photos;   //photo's dataArr

@property (nonatomic, strong) UICollectionView *timeLineView;   //时间轴
@property (nonatomic, strong) NSMutableArray *timeLineArr;  //timeline's dataArr

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) MEPhotoSelectProfile *photoSelectBrowser;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *sysPhotos;  //手机相册里的图片

@end

@implementation MEBabyPhotoProfile

- (instancetype)__initWithParmas:(NSDictionary *)params {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sj_fadeAreaViews = @[self.scrollView];
    
    [self addTest];
    
    [self customNavigation];
    
    [self layoutView];
    
    [self getOriginalImages];
}

- (void)customNavigation {
    NSString *title = @"宝宝相册";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"上传" style: UIBarButtonItemStyleDone target: self action: @selector(uploadTouchEvent)];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)getOriginalImages {
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original {
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        weakify(self);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            strongify(self);
            
            MWPhoto *mwPhoto = [MWPhoto photoWithImage: result];
            
            MEPhoto *photo = [[MEPhoto alloc] init];
            photo.image = result;
            photo.isSelect = NO;
            photo.photo = mwPhoto;
            
            [self.sysPhotos addObject: photo];
        }];
    }
}

- (void)uploadTouchEvent {
    [self.navigationController pushViewController: self.photoSelectBrowser animated: YES];
    //MWBrowser can't reuser!!! need set nil;
    _photoSelectBrowser = nil;
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

- (void)addTest {
    BOOL isSelect = NO;
    NSString *urlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523954495226&di=e9c5f86401052e2ba36dd3efca88e5c1&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201402%2F21%2F120044k1dgtgc4dg2dm5tw.jpg";
    NSURL *url = [NSURL URLWithString: urlStr];
    MWPhoto *mwPhoto = [MWPhoto photoWithURL: url];
    
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL: url]];

    for (int i = 0; i< 30; i++) {
        MEPhoto *photo = [[MEPhoto alloc] init];
        photo.isSelect = isSelect;
        photo.urlStr = urlStr;
        photo.photo = mwPhoto;
        photo.image = image;
        
        [self.photos addObject: photo];
    }
}

- (NSArray <MEPhoto *> *)selectedForUploadingPhotos {
    NSMutableArray *selectedPhotos = [NSMutableArray array];
    
    for (int i = 0; i < self.sysPhotos.count; i++) {
        if ([self.sysPhotos objectAtIndex: i].isSelect) {
            [selectedPhotos addObject: [self.sysPhotos objectAtIndex: i]];
        }
    }
    return selectedPhotos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MWPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (photoBrowser == self.photoBrowser) {
        return self.photos.count;
    } else {
        return self.sysPhotos.count;
    }
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (photoBrowser == self.photoBrowser) {
        return [self.photos objectAtIndex: index].photo;
    } else {
        return [self.sysPhotos objectAtIndex: index].photo;
    }
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (photoBrowser == self.photoBrowser) {
        return [self.photos objectAtIndex: index].photo;
    } else {
        return [self.sysPhotos objectAtIndex: index].photo;
    }
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
        return [self.sysPhotos objectAtIndex: index].isSelect;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [self.sysPhotos objectAtIndex: index].isSelect = selected;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([collectionView isEqual: self.photoView]) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual: self.photoView]) {
        return self.photos.count;
    } else {
        return self.photos.count;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if ([collectionView isEqual: self.photoView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: PHOTO_IDEF forIndexPath: indexPath];
        return cell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: TIME_LINE_IDEF forIndexPath: indexPath];
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
        UICollectionReusableView *reusableView;
        if (kind == UICollectionElementKindSectionHeader) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: TIME_LINE_SECTION_HEADER_IDEF forIndexPath: indexPath];
            if (!reusableView) {
                reusableView = [[UICollectionReusableView alloc] init];
            }
        }
        
        reusableView.backgroundColor=[UIColor cyanColor];
        return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _timeLineView) {
        return CGSizeMake(MESCREEN_HEIGHT - 20, 100);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did selected item section:%ld, item:%ld", (unsigned long)indexPath.section, (unsigned long)indexPath.item);
    
    [self.navigationController pushViewController: self.photoBrowser animated: YES];
    //MWBrowser can't reuser!!! need set nil;
    _photoBrowser = nil;
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
        _scrollContent.backgroundColor = [UIColor grayColor];
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
        _timeLineView.backgroundColor = [UIColor orangeColor];
        _timeLineView.showsVerticalScrollIndicator = NO;
        
        [_timeLineView registerNib: [UINib nibWithNibName: @"MEBabyContentPhotoCell" bundle: nil] forCellWithReuseIdentifier:  TIME_LINE_IDEF];
        
        [_timeLineView registerClass: [UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: TIME_LINE_SECTION_HEADER_IDEF];
        
    }
    return _timeLineView;
}

- (MWPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        //初始化
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        [_photoBrowser setCurrentPhotoIndex:0];
        _photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        _photoBrowser.displayNavArrows = NO; //显示左右划动
        _photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        _photoBrowser.alwaysShowControls = NO; //控制条始终显示
        _photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        _photoBrowser.enableGrid = YES;//是否允许网络查看图片
        _photoBrowser.startOnGrid = NO; //是否以网格开始;
        _photoBrowser.enableSwipeToDismiss = YES;
        _photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    }
    return _photoBrowser;
}

- (MEPhotoSelectProfile *)photoSelectBrowser {
    if (!_photoSelectBrowser) {
        //初始化
        _photoSelectBrowser = [[MEPhotoSelectProfile alloc] initWithDelegate: self];
        
        __weak typeof(self) weakSelf = self;
        _photoSelectBrowser.uploadImagesHandler = ^{
            
            NSDictionary *params = @{@"images": [weakSelf selectedForUploadingPhotos]};
            
            NSString *urlString = @"profile://root@MEPhotoProgressProfile/";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];
            [weakSelf handleTransitionError: err];
        };
        
        //set options
        [_photoSelectBrowser setCurrentPhotoIndex:0];
        _photoSelectBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        _photoSelectBrowser.displayNavArrows = NO; //显示左右划动
        _photoSelectBrowser.displaySelectionButtons = YES; //是否显示选择图片按钮
        _photoSelectBrowser.alwaysShowControls = NO; //控制条始终显示
        _photoSelectBrowser.zoomPhotosToFill = YES; //是否自适应大小
        _photoSelectBrowser.enableGrid = YES;//是否允许网络查看图片
        _photoSelectBrowser.startOnGrid = NO; //是否以网格开始;
        _photoSelectBrowser.enableSwipeToDismiss = YES;
        _photoSelectBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    }
    return _photoSelectBrowser;
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

- (NSMutableArray<MEPhoto *> *)sysPhotos {
    if (!_sysPhotos) {
        _sysPhotos = [NSMutableArray array];
    }
    return _sysPhotos;
}

@end
