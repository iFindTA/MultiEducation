//
//  MEChatContent.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyContent.h"
#import "UIView+Frame.h"
#import "MEBabyHeader.h"
#import "MEBabyContentHeader.h"
#import "MEBabyComponentCell.h"
#import "MEBabyInfoCell.h"
#import "MEStudentVM.h"
#import "MebabyIndex.pbobjc.h"
#import "MEBabyIndexVM.h"
#import "MebabyAlbum.pbobjc.h"
#import "MEBabyAlbumListVM.h"
#import "MEBabyPhotoCell.h"
#import "MEPhoto.h"

#define COMPONENT_COUNT 6
#define MAX_PHOTO_COUNT 10

#define BABY_PHOTOVIEW_IDEF @"baby_photoView_idef"
#define SCROLL_CONTENTVIEW_IDEF @"scroll_contentView_idef"
#define BABY_INFO_IDEF @"baby_info_idef"

#define TABLEVIEW_ROW_HEIGHT 102.f
#define TABLEVIEW_SECTION_HEIGHT 44.f
#define BABY_CONTENT_HEADER_HEIGHT 230.f
#define COMPONENT_HEIGHT 256.f

@interface MEBabyContent() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    CGFloat _lastContentOffset;
    BOOL show;  //did contentOffsetY already > BABY_CONTENT_HEADER_HEIGHT
}

@property (nonatomic, strong) MEBabyHeader *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;

@property (nonatomic, strong) MEBabyContentHeader *photoHeader;
@property (nonatomic, strong) UICollectionView *babyPhtoView;
@property (nonatomic, strong) NSMutableArray <MEPhoto *> *babyPhotos;   //babyPhoto

@property (nonatomic, strong) UICollectionView *componentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr; //table dataArr

@property (nonatomic, strong) StudentPb *studentPb;

@end

@implementation MEBabyContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self createSubviews];
    }
    return self;
}

- (void)loadData {
    if (self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count != 0) {
        
        GuStudentArchivesPb *stuPb;
        if ([MEBabyIndexVM fetchSelectBaby] != nil) {
            stuPb = [MEBabyIndexVM fetchSelectBaby];
            [self.headerView setData: stuPb];
            [self getBabyPhotos: stuPb.classId];
            return;
        }
        
        NSInteger studentId = self.currentUser.parentsPb.studentPbArray[0].id_p;
        [self getBabyArchitecture: studentId];
    }
}

- (void)getBabyPhotos:(NSInteger)classId {
    ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
    MEBabyAlbumListVM *babyVm = [MEBabyAlbumListVM vmWithPb: pb];
    pb.classId = classId;
    NSData *data = [pb data];
    weakify(self);
    [babyVm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        ClassAlbumListPb *albumListPb = [ClassAlbumListPb parseFromData: resObj error: nil];
        
        [self.babyPhotos removeAllObjects];
        
        for (ClassAlbumPb *pb in albumListPb.classAlbumArray) {
            MEPhoto *photo = [[MEPhoto alloc] init];
            photo.fileType = pb.fileType;
            photo.urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, pb.filePath];
            NSLog(@"%@", pb.fileType);
            [self.babyPhotos addObject: photo];
        }
        
        [self.babyPhtoView reloadData];
        [self setVideoCoverImage];
        [self updateViewsMasonry];
        
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)setVideoCoverImage {
    NSInteger index = 0;
    for (MEPhoto *photo in self.babyPhotos) {
        if ([photo.fileType isEqualToString: @"mp4"]) {
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
                    [self.babyPhtoView reloadItemsAtIndexPaths: @[[NSIndexPath indexPathForItem: index inSection: 0]]];
                });
            });
        }
        index++;
    }
}

- (void)getBabyArchitecture:(NSInteger)studenId {
    GuIndexPb *pb = [[GuIndexPb alloc] init];
    pb.studentId = studenId;
    MEBabyIndexVM *babyIndexVM = [MEBabyIndexVM vmWithPb: pb];
    NSData *data = [pb data];
    weakify(self);
    [babyIndexVM postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        GuIndexPb *pb = [GuIndexPb parseFromData: resObj error: nil];
        [self.headerView setData: pb.studentArchives];
        
        GuStudentArchivesPb *babyGrowthPb = pb.studentArchives;
        babyGrowthPb.userId = self.currentUser.id_p;
        [MEBabyIndexVM saveSelectBaby: pb.studentArchives];
        
        [self getBabyPhotos: babyGrowthPb.classId];
        
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

- (void)createSubviews {
    
    [self addSubview: self.scrollView];
    [self.scrollView addSubview: self.scrollContentView];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyHeader" owner:self options:nil] lastObject];
    weakify(self);
    self.headerView.selectCallBack = ^(StudentPb *pb) {
        strongify(self);
        [self getBabyArchitecture: pb.id_p];
    };
    [self.scrollContentView addSubview: self.headerView];

    self.photoHeader = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyContentHeader" owner:self options:nil] lastObject];
    [self.scrollContentView addSubview: self.photoHeader];
    [self.scrollContentView addSubview: self.babyPhtoView];
    [self.scrollContentView addSubview: self.componentView];
    
    
    [self.scrollContentView addSubview: self.tableView];
    
    //layoutBackContentView
    CGFloat toTop = -20.f;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(toTop);
    }];
    
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(BABY_CONTENT_HEADER_HEIGHT);
    }];
    
    if (!(self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count == 0)) {
        [self.photoHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollView);
            make.width.mas_equalTo(MESCREEN_WIDTH);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(54.f);
        }];
        
        [self.babyPhtoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.scrollContentView.mas_right).mas_offset(-10);
            make.left.mas_equalTo(self.scrollContentView.mas_left).mas_offset(10.f);
            make.height.mas_equalTo(78);
        }];
        
        [self.componentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MESCREEN_WIDTH - 20);
            make.left.mas_equalTo(_scrollContentView.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.babyPhtoView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(COMPONENT_HEIGHT);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollContentView);
            make.top.mas_equalTo(self.componentView.mas_bottom);
            make.height.mas_equalTo([self tableviewHeight]);
        }];
        
        [self.scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.tableView.mas_bottom).mas_offset(10.f);
        }];
        
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollContentView);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo([self tableviewHeight]);
        }];
        
        [self.scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.tableView.mas_bottom).mas_offset(10.f);
        }];
    }
}

- (void)updateViewsMasonry {

    if (self.babyPhotos.count == 0)  {
        
        self.photoHeader.hidden = YES;
        self.babyPhtoView.hidden = YES;
        self.componentView.hidden = YES;
        
        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerView.mas_bottom);
        }];

    } else {
        
        self.photoHeader.hidden = NO;
        self.babyPhtoView.hidden = NO;
        self.componentView.hidden = NO;
        self.tableView.hidden = NO;
        
        [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollContentView);
            make.height.mas_equalTo([self tableviewHeight]);
            make.top.mas_equalTo(self.componentView.mas_bottom);
        }];
    
    }
    
    [self.scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tableView.mas_bottom).mas_offset(10.f);
    }];

}

//let tableView.height = tableView.contentView.height  don't let it can scroll !!!
- (CGFloat)tableviewHeight {
    CGFloat height = 0;
    for (int i = 0; i < [self.tableView numberOfSections]; i++) {
        height += TABLEVIEW_SECTION_HEIGHT;
        height += [self.tableView numberOfRowsInSection: i] * TABLEVIEW_ROW_HEIGHT;
    }
    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual: self.babyPhtoView]) {
        if (self.babyPhotos.count <= MAX_PHOTO_COUNT) {
            return self.babyPhotos.count;
        } else  {
            return MAX_PHOTO_COUNT;
        }
    } else {
        return COMPONENT_COUNT;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if ([collectionView isEqual: self.babyPhtoView]) {
        //babyPhotoView collectionView cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: BABY_PHOTOVIEW_IDEF forIndexPath: indexPath];
        [(MEBabyPhotoCell *)cell setData: [self.babyPhotos objectAtIndex: indexPath.item]];
    } else {
//        scrollContentView collectionView cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: SCROLL_CONTENTVIEW_IDEF forIndexPath: indexPath];
        [(MEBabyComponentCell *)cell setItemWithType: 1 << indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        return CGSizeMake(78.f, 78.f);
    } else {
        return CGSizeMake((MESCREEN_WIDTH - 25) / 2, 82.f);
    }
}

#pragma mark - UICollectionViewLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        //babyPhotoView collectionView cell
        NSLog(@"did select babyPhotoView at indexPath.item:%ld", (long)indexPath.item);
    } else {
        //scrollContentView collectionView cell
        
        NSLog(@"did select scrollContentView at indexPath.item:%ld", (long)indexPath.item);
        NSURL *url = nil; NSDictionary *params = nil;
        if (MEBabyContentTypeLive & (1 << (NSUInteger)indexPath.item)) {
            url = [MEDispatcher profileUrlWithClass:@"MELiveRoomRootProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
        }
        NSError *err = [MEDispatcher openURL:url withParams:params];
        [self handleTransitionError:err];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: BABY_INFO_IDEF];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"育儿资讯";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLEVIEW_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select tableview in section:%ld in row:%ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.babyContentScrollCallBack) {
        MEScrollViewDirection direction;
        int currentPostion = scrollView.contentOffset.y;
        if (currentPostion - _lastContentOffset > 1) {
            _lastContentOffset = currentPostion;
            direction = MEScrollViewDirectionDown;
        } else if (_lastContentOffset - currentPostion > 1) {
            _lastContentOffset = currentPostion;
            direction = MEScrollViewDirectionUp;
        }
        
        if (!show) {
            if (scrollView.contentOffset.y >= BABY_CONTENT_HEADER_HEIGHT) {
                self.babyContentScrollCallBack(self.scrollView.contentOffset.y - BABY_CONTENT_HEADER_HEIGHT, direction);
                show = YES;
            }
        } else {
            if (scrollView.contentOffset.y < BABY_CONTENT_HEADER_HEIGHT) {
                self.babyContentScrollCallBack(self.scrollView.contentOffset.y - BABY_CONTENT_HEADER_HEIGHT, direction);
                show = NO;
            }
        }
    }
}

#pragma mark - lazyloading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollContentView;
}

- (UICollectionView *)componentView {
    if (!_componentView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 5.f;
        layout.minimumLineSpacing = 5.f;

        _componentView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _componentView.delegate = self;
        _componentView.dataSource = self;
        _componentView.backgroundColor = [UIColor whiteColor];
        _componentView.showsVerticalScrollIndicator = NO;
        
        [_componentView registerNib: [UINib nibWithNibName: @"MEBabyComponentCell" bundle: nil] forCellWithReuseIdentifier: SCROLL_CONTENTVIEW_IDEF];
    }
    return _componentView;
}

- (UICollectionView *)babyPhtoView {
    if (!_babyPhtoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        layout.itemSize =CGSizeMake(78, 78);
        layout.minimumInteritemSpacing = 5.f;
        
        _babyPhtoView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _babyPhtoView.delegate = self;
        _babyPhtoView.dataSource = self;
        _babyPhtoView.backgroundColor = [UIColor whiteColor];
        _babyPhtoView.showsHorizontalScrollIndicator = NO;
        
        [_babyPhtoView registerNib: [UINib nibWithNibName: @"MEBabyPhotoCell" bundle: nil] forCellWithReuseIdentifier: BABY_PHOTOVIEW_IDEF];
    }
    return _babyPhtoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib: [UINib nibWithNibName: @"MEBabyInfoCell" bundle: nil] forCellReuseIdentifier: BABY_INFO_IDEF];
    }
    return _tableView;
}

- (NSMutableArray *)babyPhotos {
    if (!_babyPhotos) {
        _babyPhotos = [NSMutableArray array];
    }
    return _babyPhotos;
}

@end
