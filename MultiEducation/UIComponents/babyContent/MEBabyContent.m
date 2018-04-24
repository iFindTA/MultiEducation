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
#import "Meclass.pbobjc.h"
#import "MENewsInfoVM.h"
#import "MenewsInfo.pbobjc.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

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
    NSInteger _pageIndex;
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
@property (nonatomic, strong) NSMutableArray *newsInfos; //table dataArr

@property (nonatomic, strong) StudentPb *studentPb;

@end

@implementation MEBabyContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
//        [self getBabyNewsInfo];
        [self loadData];
        [self getBabyNewsInfo];
    }
    return self;
}

- (void)loadData {
    if (self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count != 0) {
        
        GuStudentArchivesPb *stuPb;
        if ([MEBabyIndexVM fetchSelectBaby] != nil) {
            stuPb = [MEBabyIndexVM fetchSelectBaby].studentArchives;
            
            [self.headerView setData: stuPb];
            
            [self getBabyPhotos];

            return;
        }
        
        NSInteger studentId = self.currentUser.parentsPb.studentPbArray[0].id_p;
        [self getBabyArchitecture: studentId];
    }
    
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        GuStudentArchivesPb *stuPb;
        if ([MEBabyIndexVM fetchSelectBaby] != nil) {
            stuPb = [MEBabyIndexVM fetchSelectBaby].studentArchives;
            [self getBabyPhotos];
            return;
        }
        [self getBabyArchitecture: 0];
    }
    
}

- (void)getBabyNewsInfo {
    OsrInformationPb *pb = [[OsrInformationPb alloc] init];
    MENewsInfoVM *infoVM = [MENewsInfoVM vmWithPb: pb];
    
    [infoVM postData: [pb data] pageSize: ME_PAGING_SIZE pageIndex: _pageIndex hudEnable: YES success:^(NSData * _Nullable resObj, NSUInteger totalPages) {
        OsrInformationPbList *listPb = [OsrInformationPbList parseFromData: resObj error: nil];
        _pageIndex +=  ME_PAGING_SIZE;
        [self.newsInfos addObjectsFromArray: listPb.osrInformationPbArray];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
}

//获取显示宝宝相册
- (BOOL)getBabyPhotos {
    NSArray *totalAlbums = [MEBabyAlbumListVM fetchUserAllAlbum];
    
    if (totalAlbums.count <= 0) {
        [self updateViewsMasonry];
        return NO;
    }
    
    NSArray *albums;
    if (albums.count >= 10) {
        albums = [totalAlbums subarrayWithRange: NSMakeRange(0, 10)];
    } else {
        albums = totalAlbums;
    }
    [self.babyPhotos removeAllObjects];
    for (ClassAlbumPb *pb in albums) {
        MEPhoto *photo = [[MEPhoto alloc] init];
        photo.fileType = pb.fileType;
        photo.urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, pb.filePath];
        [self.babyPhotos addObject: photo];
    }
    [self updateViewsMasonry];
    [self.babyPhtoView reloadData];
    return YES;
}

//- (void)getBabyPhotos:(NSInteger)classId {
//    ClassAlbumPb *pb = [[ClassAlbumPb alloc] init];
//    MEBabyAlbumListVM *babyVm = [MEBabyAlbumListVM vmWithPb: pb];
//    pb.classId = classId;
//    NSData *data = [pb data];
//    weakify(self);
//    [babyVm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
//        strongify(self);
//        ClassAlbumListPb *albumListPb = [ClassAlbumListPb parseFromData: resObj error: nil];
//
//        [self.babyPhotos removeAllObjects];
//
//        for (ClassAlbumPb *pb in albumListPb.classAlbumArray) {
//            MEPhoto *photo = [[MEPhoto alloc] init];
//            photo.fileType = pb.fileType;
//            photo.urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, pb.filePath];
//            NSLog(@"%@", pb.fileType);
//            [self.babyPhotos addObject: photo];
//        }
//
//        [self.babyPhtoView reloadData];
//        [self setVideoCoverImage];
//        [self updateViewsMasonry];
//
//    } failure:^(NSError * _Nonnull error) {
//        [self handleTransitionError: error];
//    }];
//}

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
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        pb.studentId = studenId;
    }
    MEBabyIndexVM *babyIndexVM = [MEBabyIndexVM vmWithPb: pb];
    NSData *data = [pb data];
    weakify(self);
    [babyIndexVM postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        GuIndexPb *pb = [GuIndexPb parseFromData: resObj error: nil];
        [self.headerView setData: pb.studentArchives];
        
        GuStudentArchivesPb *babyGrowthPb = pb.studentArchives;
        [MEBabyIndexVM saveSelectBaby: pb];
        
        [self getBabyPhotos];
        
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
    if (self.currentUser.userType == MEPBUserRole_Visitor) {
        self.babyPhtoView.hidden = YES;
        self.photoHeader.hidden = YES;
        self.componentView.hidden = YES;
        [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollContentView);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo([self tableviewHeight]);
        }];
    } else  {
        if (self.babyPhotos.count == 0) {
            self.babyPhtoView.hidden = YES;
            if (self.currentUser.userType == MEPBUserRole_Parent) {
                if (self.currentUser.parentsPb.studentPbArray.count == 0) {
                    self.photoHeader.hidden = YES;
                    self.componentView.hidden = YES;
                    [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(self.scrollContentView);
                        make.top.mas_equalTo(self.headerView.mas_bottom);
                        make.height.mas_equalTo([self tableviewHeight]);
                    }];
                } else {
                    self.photoHeader.hidden = NO;
                    self.componentView.hidden = NO;
                    [self.componentView remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                        make.left.mas_equalTo(_scrollContentView.mas_left).mas_offset(10);
                        make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(10);
                        make.height.mas_equalTo(COMPONENT_HEIGHT);
                    }];
                    [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(self.scrollContentView);
                        make.top.mas_equalTo(self.componentView.mas_bottom);
                        make.height.mas_equalTo([self tableviewHeight]);
                    }];
                }
            } else {
                self.photoHeader.hidden = NO;
                [self.componentView remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                    make.left.mas_equalTo(_scrollContentView.mas_left).mas_offset(10);
                    make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(10);
                    make.height.mas_equalTo(COMPONENT_HEIGHT);
                }];
                [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(self.scrollContentView);
                    make.top.mas_equalTo(self.componentView.mas_bottom);
                    make.height.mas_equalTo([self tableviewHeight]);
                }];
            }
        } else {
            self.babyPhtoView.hidden = NO;
            self.photoHeader.hidden = NO;
            
            [self.photoHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.scrollView);
                make.width.mas_equalTo(MESCREEN_WIDTH);
                make.top.mas_equalTo(self.headerView.mas_bottom);
                make.height.mas_equalTo(54.f);
            }];
            
            [self.babyPhtoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(0);
                make.right.mas_equalTo(self.scrollContentView.mas_right).mas_offset(-10);
                make.left.mas_equalTo(self.scrollContentView.mas_left).mas_offset(10.f);
                make.height.mas_equalTo(78);
            }];
            
            [self.componentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                make.left.mas_equalTo(_scrollContentView.mas_left).mas_offset(10);
                make.top.mas_equalTo(self.babyPhtoView.mas_bottom).mas_offset(10);
                make.height.mas_equalTo(COMPONENT_HEIGHT);
            }];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.scrollContentView);
                make.top.mas_equalTo(self.componentView.mas_bottom);
                make.height.mas_equalTo([self tableviewHeight]);
            }];
        }
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
        NSUInteger __tag = (NSUInteger)indexPath.item;
        MEBabyContentType type = (1 << __tag);
        MEBabyContentType multiType = (MEBabyContentTypeGrowth|MEBabyContentTypeEvaluate);
        if (MEBabyContentTypeLive & type) {
            url = [MEDispatcher profileUrlWithClass:@"MELiveRoomRootProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
        } else if (type & multiType){
            //目前加载Cordova网页 后续替换为原生: studentId&gradeId&semester&month
            GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
            NSMutableDictionary *multiMap = [NSMutableDictionary dictionaryWithCapacity:0];
            [multiMap setObject:@(index.gradeId) forKey:@"gradeId"];
            [multiMap setObject:@(index.semester) forKey:@"semester"];
            [multiMap setObject:@(index.month) forKey:@"month"];
            BOOL whetherRoleParent = (self.currentUser.userType == MEPBUserRole_Parent);
            if (whetherRoleParent) {
                int64_t stuID = self.studentPb.id_p;
                [multiMap setObject:@(stuID) forKey:@"studentId"];
                NSString *getParamsString = [multiMap.copy uq_URLQueryString];
                if (MEBabyContentTypeGrowth & type) {
                    NSString *startPage = PBFormat(@"gu-profile.html#/show?%@", getParamsString);
                    params = @{ME_CORDOVA_KEY_TITLE:@"成长档案",ME_CORDOVA_KEY_STARTPAGE:startPage};
                } else if (MEBabyContentTypeEvaluate & type) {
                    NSString *startPage = PBFormat(@"gu-study.html#/appraise?%@", getParamsString);
                    params = @{ME_CORDOVA_KEY_TITLE:@"发展评价",ME_CORDOVA_KEY_STARTPAGE:startPage};
                }
                url = [MEDispatcher profileUrlWithClass:@"METemplateProfile" initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
            } else {
                //是否有多个班级 有则选择 无则直接进入
                NSArray <MEPBClass*>*classes = [self muticastClasses];
                if (classes.count == 0) {
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    [alert showInfo:ME_ALERT_INFO_TITILE subTitle:ME_ALERT_INFO_NONE_CLASS closeButtonTitle:ME_ALERT_INFO_ITEM_OK duration:0];
                } else if (classes.count == 1){
                    MEPBClass *cls = classes.firstObject;
                    [self muticastClassChoosenEvent4ClassName:cls.name watchType:type];
                } else {
                    /*
                    __block SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new];
                    weakify(self)
                    [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        builder.addButtonWithActionBlock(PBAvailableString(obj.name), ^ {
                            strongify(self)
                            [self muticastClassChoosenEvent4ClassName:obj.name watchType:type];
                        });
                    }];
                    builder.addButtonWithActionBlock(ME_ALERT_INFO_ITEM_CANCEL, ^ {});
                    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
                    .style(SCLAlertViewStyleInfo)
                    .title(ME_ALERT_INFO_TITILE)
                    .subTitle(@"您当前关联了多个班级，请选择班级进行查看！")
                    .duration(0);
                    showBuilder.show(builder.alertView, self.window.rootViewController);
                    return;//*/
                    
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    //Using Block
                    weakify(self)
                    [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [alert addButton:obj.name actionBlock:^(void) {
                            strongify(self)
                            [self muticastClassChoosenEvent4ClassName:obj.name watchType:type];
                        }];
                    }];
                    [alert showInfo:ME_ALERT_INFO_TITILE subTitle:@"您当前关联了多个班级，请选择班级进行查看！" closeButtonTitle:ME_ALERT_INFO_ITEM_CANCEL duration:0];
                }
                return;
            }
        } else {
            if (MEBabyContentTypeAnnounce & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"园所公告",ME_CORDOVA_KEY_STARTPAGE:@"notice.html"};
            } else if (MEBabyContentTypeSurvey & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"问卷调查",ME_CORDOVA_KEY_STARTPAGE:@"vote.html"};
            } else if (MEBabyContentTypeRecipes & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"每周食谱",ME_CORDOVA_KEY_STARTPAGE:@"cookbook.html"};
            }
            url = [MEDispatcher profileUrlWithClass:@"METemplateProfile" initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
        }
        NSError *err = [MEDispatcher openURL:url withParams:params];
        [self handleTransitionError:err];
    }
}

#pragma mark --- Logics for 成长档案 发展评价

- (NSArray<MEPBClass*>*)muticastClasses {
    NSArray <MEPBClass*>*classes;
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        classes = self.currentUser.teacherPb.classPbArray.copy;
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        classes = self.currentUser.deanPb.classPbArray.copy;
    }
    return classes;
}

- (int64_t)convertClassName2ClassID:(NSString *)clsName {
    __block int64_t clsID = 0;
    NSArray <MEPBClass*>*classes = [self muticastClasses];
    [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:clsName]) {
            clsID = obj.id_p;
            *stop = true;
        }
    }];
    return clsID;
}

- (void)muticastClassChoosenEvent4ClassName:(NSString *)clsName watchType:(MEBabyContentType)type {
    int64_t class_id = [self convertClassName2ClassID:clsName];
    GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
    NSMutableDictionary *multiMap = [NSMutableDictionary dictionaryWithCapacity:0];
    [multiMap setObject:@(index.gradeId) forKey:@"gradeId"];
    [multiMap setObject:@(index.semester) forKey:@"semester"];
    [multiMap setObject:@(index.month) forKey:@"month"];
    [multiMap setObject:@(class_id) forKey:@"classId"];
    NSString *getParamsString = [multiMap.copy uq_URLQueryString];
    NSDictionary *params;
    if (MEBabyContentTypeGrowth & type) {
        NSString *startPage = PBFormat(@"gu-profile.html#/show?%@", getParamsString);
        params = @{ME_CORDOVA_KEY_TITLE:@"成长档案",ME_CORDOVA_KEY_STARTPAGE:startPage};
    } else if (MEBabyContentTypeEvaluate & type) {
        NSString *startPage = PBFormat(@"gu-study.html#/appraise?%@", getParamsString);
        params = @{ME_CORDOVA_KEY_TITLE:@"发展评价",ME_CORDOVA_KEY_STARTPAGE:startPage};
    }
    NSURL *url = [MEDispatcher profileUrlWithClass:@"METemplateProfile" initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEBabyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier: BABY_INFO_IDEF forIndexPath: indexPath];
    [cell setData: [self.newsInfos objectAtIndex: indexPath.row]];
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

- (NSMutableArray *)newsInfos {
    if (!_newsInfos) {
        _newsInfos = [NSMutableArray array];
    }
    return _newsInfos;
}

@end
