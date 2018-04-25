//
//  MEBabyPhotoProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoProfile.h"
#import "MEBabyPhotoHeader.h"
#import <Photos/Photos.h>
#import "MEBabyAlbumListVM.h"
#import "Meclass.pbobjc.h"
#import "MebabyAlbum.pbobjc.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "MEQiniuUtils.h"
#import "MEPhotoProgressProfile.h"
#import "MEBabyContentPhotoCell.h"
#import "METimeLineSectionView.h"
#import "MEPhotoProgressProfile.h"
#import "MESideMenuManager.h"
#import <XHImageViewer.h>
#import <XHImageViewer/UIImageView+XHURLDownload.h>
#import "MEQNUploadVM.h"


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

@interface MEBabyPhotoProfile () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, TZImagePickerControllerDelegate, XHImageViewerDelegate> {
    NSInteger _classId;
    NSInteger _parendId;
    
    BOOL _isSelectStatus;
}

@property (nonatomic, strong) MEBabyPhotoHeader *header;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MEBaseScene *scrollContent;

@property (nonatomic, strong) UICollectionView *photoView;  //photo
@property (nonatomic, strong) NSMutableArray <ClassAlbumPb *> *photos;   //photo's dataArr
@property (nonatomic, strong) NSMutableArray <ClassAlbumPb *> *selectArr;    //is select for delete or move

@property (nonatomic, strong) UICollectionView *timeLineView;   //时间轴
@property (nonatomic, strong) NSMutableArray *timeLineArr;  //timeline's dataArr

@property (nonatomic, strong) TZImagePickerController *pickerProfile;

@property (nonatomic, strong) XHImageViewer *imageViewer;

@property (nonatomic, strong) MESideMenuManager *sideMenuManager;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation MEBabyPhotoProfile

- (instancetype)__initWithParmas:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _classId = [[params objectForKey: @"classId"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sj_fadeAreaViews = @[self.scrollView];
    
    [self customNavigation];
    
    [self layoutView];
    
    [self loadDataSource];
    
    [self customSideMenu];
}

- (void)customSideMenu {
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        _sideMenuManager = [[MESideMenuManager alloc] initWithMenuSuperView: self.view sideMenuCallback:^(MEUserTouchEventType type) {
            [self sideMenuTouchEvent: type];
        }];
    }
}

- (void)sideMenuTouchEvent:(MEUserTouchEventType)type {
    switch (type) {
        case MEUserTouchEventTypeUpload: {
            [self uploadPhoto];
        }
            break;
        case MEUserTouchEventTypeNewFolder: {
            [self createNewFolder];
        }
            break;
        case MEUserTouchEventTypeMove: {
            [self movePhotoOrFolder];
        }
            break;
        case MEUserTouchEventTypeDelete: {
            [self deletePhotoOrFolder];
        }
            break;
        default:
            break;
    }
}

- (void)uploadPhoto {
    [self.navigationController presentViewController: self.pickerProfile animated: YES completion: nil];
}

- (void)createNewFolder {
    weakify(self);
    [self showNewFolderAlert:^(UITextField *textField) {
        strongify(self);
        
        ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
        pb.parentId = _parendId;
        pb.classId = _classId;
        pb.fileName = textField.text;
        
        MEQNUploadVM *vm = [MEQNUploadVM vmWithPb: pb reqCode: REQ_CLASS_ALBUM_FOLDER_UPLOAD];
        
        [vm postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
            [self loadDataSource];
        } failure:^(NSError * _Nonnull error) {
            [self handleTransitionError: error];
        }];
    }];
}

- (void)movePhotoOrFolder {
    
}

- (void)deletePhotoOrFolder {
    if (_isSelectStatus) {
        return;
    }
    _isSelectStatus = YES;
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle: @"删除" style: UIBarButtonItemStyleDone target: self action: @selector(deleteBarButtonItemTouchEvent)];

    for (ClassAlbumPb *pb in self.photos) {
        pb.isSelectStatus = _isSelectStatus;
    }
    [self.photoView reloadData];
}

- (void)showNewFolderAlert:(void(^)(UITextField *textField))callback {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"新建文件夹" message: nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];

    UIAlertAction *certain = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        callback(textField);
    }];
    
    [alertController addAction: cancel];
    [alertController addAction: certain];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件夹名称";
    }];
    [self.navigationController presentViewController: alertController animated: YES completion: nil];
}

- (void)loadDataSource {
    ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
    MEBabyAlbumListVM *babyVm = [MEBabyAlbumListVM vmWithPb: pb];
    pb.classId = _classId;
    NSData *data = [pb data];
    [babyVm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        ClassAlbumListPb *pb = [ClassAlbumListPb parseFromData: resObj error: nil];
        for (ClassAlbumPb *albumPb in  pb.classAlbumArray) {
            albumPb.formatterDate = [self formatterDate: albumPb.modifiedDate];
            albumPb.isSelectStatus = NO;
            albumPb.isSelect = NO;
            [MEBabyAlbumListVM saveAlbum: albumPb];
            [self.photos addObject: albumPb];
        }
        [self.photoView reloadData];
        [self sortPhotoWithTimeLine];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}
    
- (void)sortPhotoWithTimeLine {
    NSMutableArray *dateArr = [NSMutableArray array];
    for (ClassAlbumPb *album in self.photos) {
        [dateArr addObject: album.formatterDate];
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
        for (ClassAlbumPb *album in self.photos) {
            if ([album.formatterDate isEqualToString: dateArr[i]]) {
                [tmpArr addObject: album];
            }
        }
        [dic setObject: tmpArr forKey: @"photos"];
        [self.timeLineArr addObject: dic];
    }
    [self.timeLineView reloadData];
}

- (NSString *)formatterDate:(uint64_t)date {
    NSTimeInterval time=date/1000+28800;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [dateFormatter stringFromDate: detaildate];
    return dateStr;
}

- (void)customNavigation {
    NSString *title = @"宝宝相册";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    item.rightBarButtonItem = _rightItem;
    [self.navigationBar pushNavigationItem:item animated:true];
}

//重写backitem的方法
- (void)backBarItemTouchEvent {
    if (_isSelectStatus) {
        _isSelectStatus = NO;
        _rightItem = nil;
        [self.selectArr removeAllObjects];
        for (ClassAlbumPb *pb in self.photos) {
            pb.isSelectStatus = _isSelectStatus;
        }
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void)deleteBarButtonItemTouchEvent {
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    weakify(self);
    [MEKits handleUploadPhotos: photos assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        NSString *urlStr = @"profile://root@MEPhotoProgressProfile";
        NSDictionary *params = @{@"datas": images, @"classId": [NSNumber numberWithInteger: _classId], @"parentId": [NSNumber numberWithInteger: _parendId]};
        NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
        [self handleTransitionError: error];
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    weakify(self);
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        strongify(self);
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        NSData *data = [NSData dataWithContentsOfFile: outputPath];
        weakify(self);
        [MEKits handleUploadVideos: @[data] checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable videos) {
            strongify(self);
            NSString *urlStr = @"profile://root@MEPhotoProgressProfile";
            NSDictionary *params = @{@"datas": videos, @"classId": [NSNumber numberWithInteger: _classId], @"parentId": [NSNumber numberWithInteger: _parendId]};
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
            [self handleTransitionError: error];
        }];

    } failure:^(NSString *errorMessage, NSError *error) {
        [self handleTransitionError: error];
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
        return  self.photos.count;
    } else {
        return ((NSArray *)[(NSDictionary *)[self.timeLineArr objectAtIndex: section] objectForKey: @"photos"]).count;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MEBabyContentPhotoCell *cell;
    if ([collectionView isEqual: self.photoView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: PHOTO_IDEF forIndexPath: indexPath];
        cell.handler = ^(ClassAlbumPb *pb) {
            if (pb.isSelect) {
                if (![self.selectArr containsObject: pb]) {
                    [self.selectArr addObject: pb];
                }
            } else {
                if ([self.selectArr containsObject: pb]) {
                    [self.selectArr removeObject: pb];
                }
            }
        };
        [cell setData: [self.photos objectAtIndex: indexPath.row]];
        return cell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: TIME_LINE_IDEF forIndexPath: indexPath];
        [cell setData: [[(NSDictionary *)[self.timeLineArr objectAtIndex: indexPath.section] objectForKey: @"photos"] objectAtIndex: indexPath.row]];
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
//        NSMutableArray *images = [NSMutableArray array];
//        UIImageView *selectIv;
//        NSInteger index = 0;
//        for (ClassAlbumPb *pb in self.photos) {
            UIImageView *iv = [UIImageView imageViewWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, [self.photos objectAtIndex: 0].filePath]] autoLoading:true];
//            [images addObject: iv];
//            if (index == indexPath.row) {
//                selectIv = iv;
//            }
//            index++;
//        }
//
        [self.imageViewer showWithImageViews: @[iv]  selectedView: iv];
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
        _photoView.backgroundColor = [UIColor whiteColor];
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
//        layout.headerReferenceSize = CGSizeMake(MESCREEN_HEIGHT - 20, 100);
        
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
        _pickerProfile = [[TZImagePickerController alloc] initWithMaxImagesCount: 20 delegate: self];
        _pickerProfile.allowPickingOriginalPhoto = NO;
        _pickerProfile.allowPickingVideo = YES;
    }
    return _pickerProfile;
}

- (XHImageViewer *)imageViewer {
    if (!_imageViewer) {
        _imageViewer = [[XHImageViewer alloc] init];
        _imageViewer.delegate = self;
    }
    return _imageViewer;
}

- (NSMutableArray<ClassAlbumPb *> *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

@end
