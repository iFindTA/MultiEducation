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
#import "MEQNUploadVM.h"
#import "MEAlbumDeleteVM.h"
#import "MESelectFolderProfile.h"
#import "MEPhotoBrowser.h"
#import "MEBaseNavigationProfile.h"
#import <SDWebImageDownloader.h>

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

@interface MEBabyPhotoProfile () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, TZImagePickerControllerDelegate, MWPhotoBrowserDelegate, UITextFieldDelegate> {
    NSInteger _classId;
    NSInteger _parentId;
    NSString *_navigationTitle;
    
    UIImage *_displayImage; //  当前显示要保存的图片
    
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

@property (nonatomic, strong) MESideMenuManager *sideMenuManager;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSMutableArray <NSString *> *browserPhotos;    //当前在browser中的Photo的urlString

@end

@implementation MEBabyPhotoProfile
- (instancetype)__initWithParmas:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _classId = [[params objectForKey: @"classId"] integerValue];
        _parentId = [[params objectForKey: @"parentId"] integerValue];
        _navigationTitle = [params objectForKey: @"title"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sj_fadeAreaViews = @[self.scrollView];
    
    [self customNavigation];
    
    [self layoutView];

    [self loadDataSource: _parentId];

    [self customSideMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(uploadSuccessNotification:) name: @"DID_UPLOAD_NEW_PHOTOS_SUCCESS" object: nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: @"DID_UPLOAD_NEW_PHOTOS_SUCCESS" object: nil];
}

- (void)customSideMenu {
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        weakify(self);
        _sideMenuManager = [[MESideMenuManager alloc] initWithMenuSuperView: self.view sideMenuCallback:^(MEUserTouchEventType type) {
            strongify(self);
            [self sideMenuTouchEvent: type];
        } operationMenuCallback:^{
            strongify(self);
            if (_isSelectStatus) {
                _isSelectStatus = NO;
                [self backToUnselectingStatus];
            }
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
        pb.parentId = _parentId;
        pb.classId = _classId;
        pb.isParent = YES;
        if (textField.text && ![textField.text  isEqualToString: @""]) {
            pb.fileName = textField.text;
        } else {
            pb.fileName = [NSString stringWithFormat: @"%lld", (uint64_t)[MEKits currentTimeInterval]];
        }
        
        MEQNUploadVM *vm = [MEQNUploadVM vmWithPb: pb reqCode: REQ_CLASS_ALBUM_FOLDER_UPLOAD];
        [vm postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
            weakify(self);
            [self loadDataSource: 0];
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError: error];
        }];
    }];
}

- (void)movePhotoOrFolder {
    if (_isSelectStatus) {
        return;
    }
    _isSelectStatus = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"移动到" style: UIBarButtonItemStyleDone target: self action: @selector(moveFolderOrImageToFolderTouchEvent)];
    
    for (ClassAlbumPb *pb in self.photos) {
        pb.isSelectStatus = _isSelectStatus;
    }
    [self.photoView reloadData];
}

- (void)moveFolderOrImageToFolderTouchEvent {
    if (self.selectArr.count == 0) {
        [self backToUnselectingStatus];
        return;
    }
    
    NSMutableArray *folders = [NSMutableArray array];
    for (ClassAlbumPb *pb in self.photos) {
        if (pb.isParent) {
            if (![self.selectArr containsObject: pb]) {
                [folders addObject: pb];
            }
        }
    }

    NSString *urlStr = @"profile://root@MESelectFolderProfile/";
    
    weakify(self);
    void (^moveSuccessCallback)(void) = ^() {
        strongify(self);
        _isSelectStatus = NO;
        self.navigationItem.rightBarButtonItem = nil;
        [self loadDataSource: 0];
    };
    
    NSDictionary *params = @{@"albums": self.selectArr, @"folders": folders, ME_DISPATCH_KEY_CALLBACK: moveSuccessCallback};
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)deletePhotoOrFolder {
    if (_isSelectStatus) {
        return;
    }
    
    _isSelectStatus = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"删除" style: UIBarButtonItemStyleDone target: self action: @selector(deleteButtonItemTouchEvent)];

    for (ClassAlbumPb *pb in self.photos) {
        pb.isSelectStatus = _isSelectStatus;
    }
    [self.photoView reloadData];
}

- (void)deleteButtonItemTouchEvent {
    if (self.selectArr.count == 0) {
        [self backToUnselectingStatus];
        return;
    }
    
    ClassAlbumListPb *listPb = [[ClassAlbumListPb alloc] init];
    MEAlbumDeleteVM *albumDelVM = [MEAlbumDeleteVM vmWithPb: listPb];
    for (ClassAlbumPb *pb in self.selectArr) {
        [listPb.classAlbumArray addObject: pb];
    }
    
    weakify(self);
    [albumDelVM postData: [listPb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        for (ClassAlbumPb *pb in listPb.classAlbumArray) {
            [MEBabyAlbumListVM deleteAlbum: pb];
        }
        [self loadDataSource: 0];
        _isSelectStatus = NO;
        self.navigationItem.rightBarButtonItem = nil;
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
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
    
    weakify(self)
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        strongify(self)
        textField.delegate = self;
        textField.placeholder = @"请输入文件夹名称";
    }];
    [self.navigationController presentViewController: alertController animated: YES completion: nil];
}

- (void)uploadSuccessNotification:(NSNotification *)noti {
    [self loadDataSource: 0];
}

- (void)loadDataSource:(NSInteger)parentId {
    if (parentId == 0) {
        ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
        MEBabyAlbumListVM *babyVm = [MEBabyAlbumListVM vmWithPb: pb];
        pb.classId = _classId;
        pb.parentId = parentId;
        NSData *data = [pb data];
        weakify(self)
        [babyVm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
            strongify(self)
            [self.photos removeAllObjects];
            [self.timeLineArr removeAllObjects];
            ClassAlbumListPb *pb = [ClassAlbumListPb parseFromData: resObj error: nil];
            for (ClassAlbumPb *albumPb in pb.classAlbumArray) {
                albumPb.formatterDate = [self formatterDate: albumPb.modifiedDate];
                albumPb.isSelectStatus = NO;
                albumPb.isSelect = NO;
                [MEBabyAlbumListVM saveAlbum: albumPb];
            }
            [self.photos addObjectsFromArray: [MEBabyAlbumListVM fetchAlbumsWithParentId: _parentId]];
            [self.photoView reloadData];
            [self sortPhotoWithTimeLine];
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError: error];
        }];
    } else {
        [self.photos removeAllObjects];
        [self.timeLineArr removeAllObjects];
        
        [self.photos addObjectsFromArray: [MEBabyAlbumListVM fetchAlbumsWithParentId: _parentId]];
        [self.photoView reloadData];
        [self sortPhotoWithTimeLine];
    }
}
    
- (void)sortPhotoWithTimeLine {
    NSArray *allPhotos = [MEBabyAlbumListVM fetchAlbmsWithClassId: _classId];
    NSMutableArray *dateArr = [NSMutableArray array];
    for (ClassAlbumPb *album in allPhotos) {
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
        for (ClassAlbumPb *album in allPhotos) {
            if ([album.formatterDate isEqualToString: dateArr[i]] && !album.isParent) {
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
    NSString *title = _navigationTitle;
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self action:@selector(backBarItemTouchEvent)];
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    self.navigationItem.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:self.navigationItem animated:true];
}

//重写backitem的方法
- (void)backBarItemTouchEvent {
    if (_isSelectStatus) {
        [self backToUnselectingStatus];
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void)backToUnselectingStatus {
    _isSelectStatus = NO;
    [self.selectArr removeAllObjects];
    self.navigationItem.rightBarButtonItem = nil;
    for (ClassAlbumPb *pb in self.photos) {
        pb.isSelectStatus = NO;
        pb.isSelect = NO;
    }
    [self.photoView reloadData];
}

- (void)reloadData {
    [self.photoView reloadData];
    [self.timeLineView reloadData];
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
        make.top.mas_equalTo(self.view).mas_offset([MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR);
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
    
    CGFloat height = MESCREEN_HEIGHT - ME_HEIGHT_NAVIGATIONBAR - [MEKits statusBarHeight] - HEADER_HEIGHT;
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

- (void)didSelectAlbumPb:(ClassAlbumPb *)pb photos:(NSArray <ClassAlbumPb *> *)photos {
    NSString *bucket = self.currentUser.bucketDomain;
    if (!pb.isParent) {
        NSInteger index = 0;
        int i = 0;
        for (ClassAlbumPb *albumPb in photos) {
            if (!albumPb.isParent) {
                if ([albumPb isEqual: pb]) {
                    index = i;
                }
                NSString *urlStr;
                if ([albumPb.fileType isEqualToString: @"mp4"]) {
                    urlStr = [NSString stringWithFormat: @"%@/%@", bucket, albumPb.filePath];
                } else {
                    urlStr = [NSString stringWithFormat: @"%@/%@", bucket, albumPb.filePath];
                }
                [self.browserPhotos addObject: urlStr];
                i++;
            }
        }
        [self.photoBrowser setCurrentPhotoIndex: index];
        
        MEBaseNavigationProfile *browser  = [[MEBaseNavigationProfile alloc] initWithRootViewController: self.photoBrowser];
        [self.navigationController presentViewController: browser animated: YES completion: nil];
    } else {
        NSString *urlStr = @"profile://root@MEBabyPhotoProfile";
        NSDictionary *params = @{@"classId": [NSNumber numberWithInteger: _classId], @"parentId": [NSNumber numberWithInteger: pb.id_p], @"title": pb.fileName};
        NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
        [MEKits handleError: error];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)longPressPhotoEvent:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: nil message: nil preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *certain = [UIAlertAction actionWithTitle: @"保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(_displayImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
        
        [alertController addAction: certain];
        [alertController addAction: cancel];
        [self.photoBrowser.navigationController presentViewController: alertController animated: YES completion: nil];
    }
}

// 保存图片后到相册后,回调的相关方法,查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [MEKits handleError: error];
    } else {
        [MEKits handleSuccess: @"保存成功"];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    weakify(self);
    [MEKits handleUploadPhotos: photos assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        NSString *urlStr = @"profile://root@MEPhotoProgressProfile";
        NSDictionary *params = @{@"datas": images, @"classId": [NSNumber numberWithInteger: _classId], @"parentId": [NSNumber numberWithInteger: _parentId]};
        NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
        [MEKits handleError: error];
        self.pickerProfile = nil;
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
            NSDictionary *params = @{@"datas": videos, @"classId": [NSNumber numberWithInteger: _classId], @"parentId": [NSNumber numberWithInteger: _parentId]};
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
            [MEKits handleError: error];
            self.pickerProfile = nil;
        }];

    } failure:^(NSString *errorMessage, NSError *error) {
        [MEKits handleError: error];
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
        weakify(self)
        cell.handler = ^(ClassAlbumPb *pb) {
            strongify(self)
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString: @"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    if ([MEKits stringContainsEmoji: string]) {
        [SVProgressHUD showErrorWithStatus: @"文件夹名称无法包含emoji符号"];
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isSelectStatus) {
        if (collectionView == self.photoView) {
            ClassAlbumPb *pb = [self.photos objectAtIndex: indexPath.row];
            [self didSelectAlbumPb: pb photos: self.photos];
        } else {
            ClassAlbumPb *pb = [[(NSDictionary *)[self.timeLineArr objectAtIndex: indexPath.section] objectForKey: @"photos"] objectAtIndex: indexPath.row];
            NSArray *timeLineArr = [(NSDictionary *)[self.timeLineArr objectAtIndex: indexPath.section] objectForKey: @"photos"];
            [self didSelectAlbumPb: pb photos: timeLineArr];
        }
    } else {
        MEBabyContentPhotoCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
        [cell changeSelectBtnStatus];
        ClassAlbumPb *pb = [self.photos objectAtIndex: indexPath.row];
        if (pb.isSelect) {
            if (![self.selectArr containsObject: pb]) {
                [self.selectArr addObject: pb];
            }
        } else {
            if ([self.selectArr containsObject: pb]) {
                [self.selectArr removeObject: pb];
            }
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.browserPhotos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSString *urlStr = [self.browserPhotos objectAtIndex: index];
    MWPhoto *photo;
    if ([urlStr hasSuffix: @".mp4"]) {
        photo = [MWPhoto videoWithURL: [NSURL URLWithString: urlStr]];
    } else {
        photo = [MWPhoto photoWithURL: [NSURL URLWithString: urlStr]];
    }
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressPhotoEvent:)];
    [self.photoBrowser.view addGestureRecognizer: longPressGes];

    return photo;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    _photoBrowser = nil;
    [self.browserPhotos removeAllObjects];
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    _displayImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [self.browserPhotos objectAtIndex: index]]]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
        [self.header markLineAnimation: page];
        if (scrollView.contentOffset.x == MESCREEN_WIDTH) {
            [self.sideMenuManager hideSideMenuManager];
        } else {
            [self.sideMenuManager showSideMenuManager];
        }
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

- (NSMutableArray<ClassAlbumPb *> *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (MWPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        _photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        _photoBrowser.displayNavArrows = NO; //显示左右划动
        _photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        _photoBrowser.alwaysShowControls = YES; //控制条始终显示
        _photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        _photoBrowser.enableGrid = NO;//是否允许网络查看图片
        _photoBrowser.startOnGrid = NO; //是否以网格开始;
        _photoBrowser.enableSwipeToDismiss = YES;
        _photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    }
    return _photoBrowser;
}

- (NSMutableArray *)browserPhotos {
    if (!_browserPhotos) {
        _browserPhotos = [NSMutableArray array];
    }
    return _browserPhotos;
}

@end
