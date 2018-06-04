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
#import "Meclass.pbobjc.h"
#import "MENewsInfoVM.h"
#import "MenewsInfo.pbobjc.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>
#import <MWPhotoBrowser.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MEBabyArchiveProfile.h"

#define COMPONENT_COUNT 9
#define MAX_PHOTO_COUNT 10

#define BABY_PHOTOVIEW_IDEF @"baby_photoView_idef"
#define SCROLL_CONTENTVIEW_IDEF @"scroll_contentView_idef"
#define BABY_INFO_IDEF @"baby_info_idef"

#define TABLEVIEW_ROW_HEIGHT 102.f
#define TABLEVIEW_SECTION_HEIGHT 44.f
#define BABY_CONTENT_HEADER_HEIGHT 230.f
#define BABY_PHOTO_HEADER_HEIGHT 54.f
#define COMPONENT_HEIGHT 232.f
#define BABY_PHOTO_HEIGHT 78.f
#define GAP_BETWEEN_COMPONENT_PHOTOCONTENT 5.f
#define TABLEVIEW_HEIGHT MESCREEN_HEIGHT - ME_HEIGHT_TABBAR
#define COMPONENT_CELL_SIZE  CGSizeMake(adoptValue(113.f), 72.f);

@interface MEBabyContent() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    CGFloat _lastContentOffset;
    NSInteger _pageIndex;
    BOOL show;  //did contentOffsetY already > BABY_CONTENT_HEADER_HEIGHT
    
    BOOL _whetherGraduate;    //显示 @"假期通知" || @"毕业通知"
}

@property (nonatomic, strong) MEBaseScene *tableHeaderView;

@property (nonatomic, strong) MEBabyHeader *headerView;

@property (nonatomic, strong) MEBabyContentHeader *photoHeader;
@property (nonatomic, strong) UICollectionView *babyPhtoView;

@property (nonatomic, strong) UICollectionView *componentView;

@property (nonatomic, strong) NSMutableArray *babyPhotos;   //babyPhoto

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsInfos; //table dataArr

@property (nonatomic, strong) StudentPb *studentPb;

@property (nonatomic, strong) NSMutableArray <NSNumber *> *badgeArr;

@property (nonatomic, strong) NSMutableArray <MWPhoto *> *browserPhotos;    //当前在browser中的Photo

@end

@implementation MEBabyContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self loadData];
        [self getBabyNewsInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(getBabyPhotos) name: @"DID_UPLOAD_NEW_PHOTOS_SUCCESS" object: nil];
    }
    return self;
}

- (void)removeNotiObserver {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: @"DID_UPLOAD_NEW_PHOTOS_SUCCESS" object: nil];
}

- (void)loadData {
    if (self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count != 0) {
        GuStudentArchivesPb *stuPb;
        if ([MEBabyIndexVM fetchSelectBaby] != nil) {
            stuPb = [MEBabyIndexVM fetchSelectBaby].studentArchives;
            _whetherGraduate = [MEBabyIndexVM fetchSelectBaby].showGraduate;
            [self.headerView setData: stuPb];
            [self getBabyPhotos];
            [self getBabyGrowthIndexbadgeWhichRoleParent: stuPb.studentId];
            self.studentPb.id_p = stuPb.studentId;
            return;
        }
        NSInteger studentId = self.currentUser.parentsPb.studentPbArray[0].id_p;
        self.studentPb.id_p = studentId;
        [self getBabyArchitecture: studentId];
    }
    
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        [self getBabyPhotos];
        [self getBabyArchitecture: 0];
    }
}

//role == parent 由于会保存信息，所以不会请求GuIndexPb,无法获取最新的badge
- (void)getBabyGrowthIndexbadgeWhichRoleParent:(NSInteger)studentId {
    GuIndexPb *pb = [[GuIndexPb alloc] init];
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        pb.studentId = studentId;
    }
    MEBabyIndexVM *babyIndexVM = [MEBabyIndexVM vmWithPb: pb];
    NSData *data = [pb data];
    weakify(self);
    [babyIndexVM postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        strongify(self);
        GuIndexPb *pb = [GuIndexPb parseFromData: resObj error: nil];
        [self.badgeArr replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger: pb.unNoticeNum]];
        [self.badgeArr replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger: pb.unVoteNum]];
        if (self.babyTabBarBadgeCallback) {
            self.babyTabBarBadgeCallback(pb.unVoteNum + pb.unNoticeNum);
        }
        [self.componentView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)getBabyNewsInfo {
    OsrInformationPb *pb = [[OsrInformationPb alloc] init];
    MENewsInfoVM *infoVM = [MENewsInfoVM vmWithPb: pb];
    [infoVM postData: [pb data] pageSize: ME_PAGING_SIZE pageIndex: _pageIndex hudEnable: YES success:^(NSData * _Nullable resObj, int32_t totalPages) {
        OsrInformationPbList *listPb = [OsrInformationPbList parseFromData: resObj error: nil];
        _pageIndex +=  ME_PAGING_SIZE;
        [self.newsInfos addObjectsFromArray: listPb.osrInformationPbArray];        
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

//获取显示宝宝相册
- (BOOL)getBabyPhotos {
    [self.babyPhotos removeAllObjects];
    NSArray *totalAlbums;
    if (self.currentUser.userType == MEPBUserRole_Gardener || self.currentUser.userType == MEPBUserRole_Teacher) {
        totalAlbums = [MEBabyAlbumListVM fetchUserAllAlbum];
    } else if (self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count != 0) {
        GuStudentArchivesPb *pb = [MEBabyIndexVM fetchSelectBaby].studentArchives;
        totalAlbums = [MEBabyAlbumListVM fetchAlbmsWithClassId: pb.classId];
    } else {
        [self updateViewsMasonry];
        return NO;
    }
    if (totalAlbums.count <= 0) {
        [self updateViewsMasonry];
        return NO;
    }
    
    NSMutableArray *albums = [NSMutableArray array];
    
    for (ClassAlbumPb *pb in totalAlbums) {
        if (albums.count < (totalAlbums.count >= 10 ? 10 : totalAlbums.count)) {
            if (!pb.isParent) {
                [albums addObject: pb];
            }
        } else {
            break;
        }
    }
    
    [self.babyPhotos addObjectsFromArray: albums];
    [self updateViewsMasonry];
    [self.babyPhtoView reloadData];
    
    [self.browserPhotos removeAllObjects];
    for (ClassAlbumPb *pb in self.babyPhotos) {
        MWPhoto *photo;
        if ([pb.fileType isEqualToString: @"mp4"]) {
            photo = [[MWPhoto alloc] initWithVideoURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", self.currentUser.bucketDomain, pb.filePath]]];
        } else {
            photo = [[MWPhoto alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", self.currentUser.bucketDomain, pb.filePath]]];
        }
        [self.browserPhotos addObject: photo];
    }
    
    return YES;
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
        [MEBabyIndexVM saveSelectBaby: pb];
        _whetherGraduate = pb.showGraduate;
        [self getBabyPhotos];
        
        [self.badgeArr replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger: pb.unNoticeNum]];
        [self.badgeArr replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger: pb.unVoteNum]];
        [self.componentView reloadData];
        if (self.babyTabBarBadgeCallback) {
            self.babyTabBarBadgeCallback(pb.unVoteNum + pb.unNoticeNum);
        }
        if (self.didChangeSelectedBaby) {
            self.didChangeSelectedBaby(pb.studentArchives.studentName, pb.studentArchives.studentPortrait);
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)createSubviews {
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyHeader" owner:self options:nil] lastObject];
    weakify(self);
    self.headerView.selectCallBack = ^(StudentPb *pb) {
        strongify(self);
        [self getBabyArchitecture: pb.id_p];
    };
    
    self.photoHeader = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyContentHeader" owner:self options:nil] lastObject];
    self.photoHeader.DidChangePhotoCallback = ^{
        strongify(self);
        [self loadData];
    };
    [self.tableHeaderView addSubview: self.headerView];
    [self addSubview: self.tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //layoutBackContentView
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.tableHeaderView);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(BABY_CONTENT_HEADER_HEIGHT);
    }];
    
    if (!(self.currentUser.userType == MEPBUserRole_Parent && self.currentUser.parentsPb.studentPbArray.count == 0)) {
        
        [self.tableHeaderView addSubview: self.photoHeader];
        [self.tableHeaderView addSubview: self.babyPhtoView];
        [self.tableHeaderView addSubview: self.componentView];
        
        [self.photoHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tableHeaderView);
            make.width.mas_equalTo(MESCREEN_WIDTH);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(BABY_PHOTO_HEADER_HEIGHT);
        }];
        
        [self.babyPhtoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10.f);
            make.width.mas_equalTo(MESCREEN_WIDTH - 20);
            make.height.mas_equalTo(BABY_PHOTO_HEIGHT);
        }];
        
        [self.componentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MESCREEN_WIDTH - 20);
            make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.babyPhtoView.mas_bottom).mas_offset(GAP_BETWEEN_COMPONENT_PHOTOCONTENT);
            make.height.mas_equalTo(COMPONENT_HEIGHT);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(TABLEVIEW_HEIGHT);
            make.width.mas_equalTo(MESCREEN_WIDTH);
        }];
        
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(TABLEVIEW_HEIGHT);
            make.width.mas_equalTo(MESCREEN_WIDTH);
        }];
        self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT;
    }
}

- (void)updateViewsMasonry {
    if (self.currentUser.userType == MEPBUserRole_Visitor) {
        self.babyPhtoView.hidden = YES;
        self.photoHeader.hidden = YES;
        self.componentView.hidden = YES;
        self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT;
    } else  {
        if (self.babyPhotos.count == 0) {
            self.babyPhtoView.hidden = YES;
            if (self.currentUser.userType == MEPBUserRole_Parent) {
                if (self.currentUser.parentsPb.studentPbArray.count == 0) {
                    self.photoHeader.hidden = YES;
                    self.componentView.hidden = YES;
                    self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT;
                } else {
                    self.photoHeader.hidden = NO;
                    self.componentView.hidden = NO;
                    [self.componentView remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                        make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10);
                        make.top.mas_equalTo(self.photoHeader.mas_bottom);
                        make.height.mas_equalTo(COMPONENT_HEIGHT);
                    }];
                    self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT + BABY_PHOTO_HEADER_HEIGHT + COMPONENT_HEIGHT + GAP_BETWEEN_COMPONENT_PHOTOCONTENT;
                }
            } else {
                self.photoHeader.hidden = NO;
                [self.componentView remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                    make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10);
                    make.top.mas_equalTo(self.photoHeader.mas_bottom);
                    make.height.mas_equalTo(COMPONENT_HEIGHT);
                }];
                self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT + BABY_PHOTO_HEADER_HEIGHT + COMPONENT_HEIGHT + GAP_BETWEEN_COMPONENT_PHOTOCONTENT;
            }
        } else {
            self.babyPhtoView.hidden = NO;
            self.photoHeader.hidden = NO;
            [self.photoHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.tableHeaderView);
                make.width.mas_equalTo(MESCREEN_WIDTH);
                make.top.mas_equalTo(self.headerView.mas_bottom);
                make.height.mas_equalTo(54.f);
            }];
            
            [self.babyPhtoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(0);
                make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10.f);
                make.height.mas_equalTo(BABY_PHOTO_HEIGHT);
                make.width.greaterThanOrEqualTo(@0);
            }];
            
            [self.componentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(MESCREEN_WIDTH - 20);
                make.left.mas_equalTo(self.tableHeaderView.mas_left).mas_offset(10);
                make.top.mas_equalTo(self.babyPhtoView.mas_bottom).mas_offset(GAP_BETWEEN_COMPONENT_PHOTOCONTENT);
                make.height.mas_equalTo(COMPONENT_HEIGHT);
            }];
            self.tableHeaderView.height = BABY_CONTENT_HEADER_HEIGHT + BABY_PHOTO_HEADER_HEIGHT + COMPONENT_HEIGHT + BABY_PHOTO_HEIGHT + GAP_BETWEEN_COMPONENT_PHOTOCONTENT;
        }
    }
}

- (NSDictionary *)pushToBabyInterestingPorfile {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEBabyInterestProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
    NSDictionary *params = [NSDictionary dictionary];
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        if (self.currentUser.teacherPb.classPbArray.count > 0) {
            if (self.currentUser.teacherPb.classPbArray.count > 1) {
                params = @{@"pushUrlStr": @"profile://root@MEBabyInterestProfile/", @"title": @"趣事趣影"};
                url = [MEDispatcher profileUrlWithClass:@"METeacherMultiClassTableProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
            } else {
                params = @{@"classPb": (self.currentUser.teacherPb.classPbArray[0])};
            }
        } else {
           [MEKits makeToast: ME_ALERT_INFO_NONE_CLASS];
        }
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        if (self.currentUser.deanPb.classPbArray.count > 0) {
            if (self.currentUser.deanPb.classPbArray.count > 1) {
                params = @{@"pushUrlStr": @"profile://root@MEBabyInterestProfile/", @"title": @"趣事趣影"};
                url = [MEDispatcher profileUrlWithClass: @"METeacherMultiClassTableProfile" initMethod: nil params: nil instanceType: MEProfileTypeCODE];
            } else {
                params = @{@"classPb": (self.currentUser.deanPb.classPbArray[0])};
            }
        } else {
            [MEKits makeToast: ME_ALERT_INFO_NONE_CLASS];
        }
    } else {

    }
    
    [dic setObject: url forKey: @"url"];
    [dic setObject: params forKey: @"params"];
    return dic;
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
        [(MEBabyPhotoCell *)cell setData: [self.babyPhotos objectAtIndex: indexPath.row]];
    } else {
        //component
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: SCROLL_CONTENTVIEW_IDEF forIndexPath: indexPath];
        [(MEBabyComponentCell *)cell setItemWithType: 1 << indexPath.item badge: [self.badgeArr objectAtIndex: indexPath.item].integerValue whetherGraduate: _whetherGraduate];
    }
    return cell;
}

#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        return CGSizeMake(78.f, 78.f);
    } else {
        return COMPONENT_CELL_SIZE;
    }
}

#pragma mark - UICollectionViewLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        //babyPhotoView collectionView cell
        if (self.DidSelectHandler) {
            self.DidSelectHandler(indexPath.item, self.browserPhotos);
        }
    } else {
        BOOL whetherRoleParent = (self.currentUser.userType == MEPBUserRole_Parent);
        //scrollContentView collectionView cell
        NSURL *url = nil; NSDictionary *params = nil;
        NSUInteger __tag = (NSUInteger)indexPath.item;
        MEBabyContentType type = (1 << __tag);
        MEBabyContentType multiType = (MEBabyContentTypeGrowth|MEBabyContentTypeEvaluate|MEBabyContentTypeTermEvaluate);
        NSString *buried_point = nil;
        if (MEBabyContentTypeLive & type) {
            url = [MEDispatcher profileUrlWithClass:@"MELiveRoomRootProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
            buried_point = Buried_CLASS_LIVE;
        } else if(MEBabyContentTypeInterest & type) {
            //趣事趣影
            NSDictionary *dic = [self pushToBabyInterestingPorfile];
            url = [dic objectForKey: @"url"];
            params = [dic objectForKey: @"params"];
            buried_point = Buried_CLASS_INTERESTING;
            if ((self.currentUser.userType == MEPBUserRole_Gardener) || (self.currentUser.userType == MEPBUserRole_Teacher)) {
                if (![params objectForKey: @"classPb"] && ![params objectForKey: @"pushUrlStr"]) {
                    [MEKits makeToast: @"暂无绑定班级"];
                    return;
                }
            }
        } else if (type & multiType){
            //Cordova替换为原生: studentId&gradeId&semester&month
            if (whetherRoleParent) {
                [self userDidChoosenType:type whetherParent:true className:nil];
                return;
            } else {
                //是否有多个班级 有则选择 无则直接进入
                NSArray <MEPBClass*>*classes = [self muticastClasses];
                if (classes.count == 0) {
                    [MEKits makeToast:ME_ALERT_INFO_NONE_CLASS];
                } else if (classes.count == 1){
                    MEPBClass *cls = classes.firstObject;
                    [self userDidChoosenType:type whetherParent:false className:cls.name];
                } else {
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    //Using Block
                    weakify(self)
                    [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [alert addButton:obj.name actionBlock:^(void) {
                            strongify(self)
                            [self userDidChoosenType:type whetherParent:false className:obj.name];
                        }];
                    }];
                    [alert showInfo:ME_ALERT_INFO_TITILE subTitle:@"您当前关联了多个班级，请选择班级进行查看！" closeButtonTitle:ME_ALERT_INFO_ITEM_CANCEL duration:0];
                }
                return;
            }
        } else {
            if (MEBabyContentTypeAnnounce & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"园所公告",ME_CORDOVA_KEY_STARTPAGE:@"notice.html"};
                buried_point = Buried_CLASS_PARK_NOTICE;
            } else if (MEBabyContentTypeSurvey & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"问卷调查",ME_CORDOVA_KEY_STARTPAGE:@"vote.html"};
                buried_point = Buried_CLASS_QUESTIONNAIRE;
            } else if (MEBabyContentTypeRecipes & type) {
                params = @{ME_CORDOVA_KEY_TITLE:@"每周食谱",ME_CORDOVA_KEY_STARTPAGE:@"cookbook.html"};
                buried_point = Buried_CLASS_WEEKLY_RECIPES;
            } else if (MEBabyContentTypeHolidayAnnounce & type) {
                GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
                NSString *startPage = @"gu_holiday_notice.html#/main";
                NSString *title = @"假期通知";
                if (index.showGraduate) {
                    title = @"毕业通知";
                    startPage = @"gu_graduate.html#/gu_graduate";
                }
                if (whetherRoleParent) {
                    int64_t studentId = index.studentArchives.studentId;
                    startPage = PBFormat(@"%@?studentId=%lld", startPage, studentId);
                }
                params = @{ME_CORDOVA_KEY_TITLE:title,ME_CORDOVA_KEY_STARTPAGE:startPage};
                buried_point = Buried_CLASS_VACATION;
            }
            url = [MEDispatcher profileUrlWithClass:@"METemplateProfile" initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
        }
        //埋点
        [MobClick event:buried_point];
        NSError *err = [MEDispatcher openURL:url withParams:params];
        [MEKits handleError:err];
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

- (MEPBClass *)convertClassName2Class:(NSString *)clsName {
    __block MEPBClass *cls = 0;
    NSArray <MEPBClass*>*classes = [self muticastClasses];
    [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:clsName]) {
            cls = obj;
            *stop = true;
        }
    }];
    return cls;
}

/**
 家长/老师/园务 查看
 */
- (void)userDidChoosenType:(MEBabyContentType)type whetherParent:(BOOL)parent className:(NSString *)clsName {
    NSMutableDictionary *multiMap = [NSMutableDictionary dictionaryWithCapacity:0];
    GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
    [multiMap setObject:@(index.month) forKey:@"month"];
    if (parent) {
        int64_t stud_id = index.studentArchives.studentId;
        StudentPb *studnt;
        for (StudentPb *s in self.currentUser.parentsPb.studentPbArray) {
            if (s.id_p == stud_id) {
                studnt = s;
                break;
            }
        }
        [multiMap setObject:@(stud_id) forKey:@"studentId"];
        [multiMap setObject:@(studnt.classId) forKey:@"classId"];
        [multiMap setObject:@(index.gradeId) forKey:@"gradeId"];
        [multiMap setObject:@(index.semester) forKey:@"semester"];
    } else {
        MEPBClass *cls = [self convertClassName2Class:clsName];
        [multiMap setObject:@(cls.id_p) forKey:@"classId"];
        [multiMap setObject:@(cls.gradeId) forKey:@"gradeId"];
        [multiMap setObject:@(cls.semester) forKey:@"semester"];
        [multiMap setObject:cls.name forKey:@"className"];
    }
    NSString *destProfile;NSURL *url = nil; NSDictionary *params = nil;NSString *buried_point = nil;
    if (MEBabyContentTypeGrowth & type) {
//        NSString *getParamsString = [multiMap.copy uq_URLQueryString];
//        NSString *startPage = PBFormat(@"gu-profile.html#/show?%@", getParamsString);
//        params = @{ME_CORDOVA_KEY_TITLE:@"成长档案",ME_CORDOVA_KEY_STARTPAGE:startPage};
        params = multiMap.copy;
        destProfile = @"MEBabyArchiveProfile";
        buried_point = Buried_CLASS_ARCHIVE;
    } else if (MEBabyContentTypeEvaluate & type) {
        params = multiMap.copy;
        destProfile = @"MEGrowthEvaRootProfile";
        buried_point = Buried_CLASS_EVALUATE;
    } else if (MEBabyContentTypeTermEvaluate) {
        params = multiMap.copy;
        destProfile = @"MESemesterEvaRootProfile";
        buried_point = Buried_CLASS_SEMESTER;
    }
    url = [MEDispatcher profileUrlWithClass:destProfile initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
    //埋点
    [MobClick event:buried_point];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [MEKits handleError:err];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsInfos.count;
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
    if (self.newsInfos.count == 0) {
        return 0;
    } else {
        return TABLEVIEW_SECTION_HEIGHT;
    }
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLEVIEW_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"did select tableview in section:%ld in row:%ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (indexPath.row >= self.newsInfos.count) {
        return;
    }
    OsrInformationPb *newsInfo = self.newsInfos[indexPath.row];
    NSString *title = PBAvailableString(newsInfo.title);
    NSString *startPage = PBFormat(@"information.html#/information/%lld", newsInfo.id_p);
    NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:title,ME_CORDOVA_KEY_STARTPAGE:startPage};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"METemplateProfile" initMethod:@"__initWithParams:" params:nil instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [MEKits handleError:err];
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
                self.babyContentScrollCallBack(self.tableView.contentOffset.y - BABY_CONTENT_HEADER_HEIGHT, direction);
                show = YES;
            }
        } else {
            if (scrollView.contentOffset.y < BABY_CONTENT_HEADER_HEIGHT) {
                self.babyContentScrollCallBack(self.tableView.contentOffset.y - BABY_CONTENT_HEADER_HEIGHT, direction);
                show = NO;
            }
        }
    }
}

#pragma mark - lazyloading
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
        _tableView.separatorColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
        _tableView.tableHeaderView = self.tableHeaderView;
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

- (NSMutableArray<NSNumber *> *)badgeArr {
    if (!_badgeArr) {
        NSArray *tmpArr = @[@0, @0, @0, @0, @0, @0, @0, @0, @0];
        _badgeArr = [NSMutableArray arrayWithArray: tmpArr];
    }
    return _badgeArr;
}

- (NSMutableArray *)browserPhotos {
    if (!_browserPhotos) {
        _browserPhotos = [NSMutableArray array];
    }
    return _browserPhotos;
}

- (MEBaseScene *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MEBaseScene alloc] initWithFrame: CGRectMake(0, 0, MESCREEN_WIDTH, BABY_CONTENT_HEADER_HEIGHT + BABY_PHOTO_HEADER_HEIGHT + COMPONENT_HEIGHT + BABY_PHOTO_HEIGHT)];
    }
    return _tableHeaderView;
}

- (StudentPb *)studentPb {
    if (!_studentPb) {
        _studentPb = [[StudentPb alloc] init];
    }
    return _studentPb;
}
@end
