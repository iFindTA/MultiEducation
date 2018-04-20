//
//  MELiveRoomRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveClassVM.h"
#import <MJRefresh/MJRefresh.h>
#import "MELiveRoomRootProfile.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MELiveRoomRootProfile () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 当前用户是否是老师
 */
@property (nonatomic, assign) BOOL whetherTeacherRole;

/**
 当前用户选择的班级
 */
@property (nonatomic, strong, nullable) NSArray<MEPBClass*>*classes;
@property (nonatomic, strong, nullable) MEPBClass *currentClass;

@property (nonatomic, strong) MEBaseTableView *table;
@property (nonatomic, strong) MEPBClassLive *dataLive;

@property (nonatomic, assign) BOOL whetherDidLoadData;
@property (nonatomic, copy, nullable) NSString *emptyTitle, *emptyDesc;

@end

@implementation MELiveRoomRootProfile

- (PBNavigationBar *)initializedNavigationBar {
    
    if (!self.navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(ME_THEME_COLOR_TEXT);
        UIColor *barTintColor = pbColorMake(0xFFFFFF);//影响背景
        UIFont *font = [UIFont boldSystemFontOfSize:PBFontTitleSize + PBFONT_OFFSET];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(PB_NAVIBAR_SHADOW_HEX)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        
        return naviBar;
    }
    
    return self.navigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [self backBarButtonItemWithIconUnicode:@"\U0000e6e2" color:pbColorMake(ME_THEME_COLOR_TEXT)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"直播课堂"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    // add table
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.whetherDidLoadData = false;
    
    [self __initLiveRoomSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.currentClass && !self.whetherDidLoadData) {
        [self preDealWithMulticastClasses];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy getter

- (MEBaseTableView *)table {
    if (!_table) {
        _table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

#pragma mark --- DZNEmpty DataSource & Deleagte

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.whetherDidLoadData;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *imgColor =UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *image = [UIImage pb_iconFont:nil withName:ME_ICONFONT_EMPTY_HOLDER withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = PBAvailableString(self.emptyTitle);
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = PBAvailableString(self.emptyDesc);
    if ([[PBService shared] netState] == PBNetStateUnavaliable) {
        text = ME_EMPTY_PROMPT_NETWORK;
    }
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSC(METHEME_FONT_SUBTITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return adoptValue(ME_EMPTY_PROMPT_OFFSET);
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return true;
}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    [self autoLoadMoreRelevantItems4PageIndex:1];
//}

#pragma mark --- 用户角色没有关联任何班级 显示没有班级 并引导用户去关联班级

/**
 当前用户是否已经关联班级
 否则显示未关联 是则下一步
 */
- (BOOL)whetherCurrentUserDidRelatedClass {
    __block BOOL didRelated = false;
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        //老师
        TeacherPb *teacher = self.currentUser.teacherPb;
        didRelated = (teacher.classPbArray.count > 0);
    } else if (self.currentUser.userType == MEPBUserRole_Parent) {
        //家长
        ParentsPb *parent = self.currentUser.parentsPb;
        didRelated = (parent.classPbArray.count > 0);
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        //园务
        DeanPb *dean = self.currentUser.deanPb;
        didRelated = (dean.classPbArray.count > 0);
    }
    return didRelated;
}

/**
 当前用户关联的班级
 */
- (NSArray<MEPBClass*>*)fetchMulticastClasses {
    __block NSMutableArray<MEPBClass*> *classes = [NSMutableArray arrayWithCapacity:0];
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        //老师
        TeacherPb *teacher = self.currentUser.teacherPb;
        [classes addObjectsFromArray:teacher.classPbArray.copy];
    } else if (self.currentUser.userType == MEPBUserRole_Parent) {
        //家长
        ParentsPb *parent = self.currentUser.parentsPb;
        [classes addObjectsFromArray:parent.classPbArray.copy];
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        //园务
        DeanPb *dean = self.currentUser.deanPb;
        [classes addObjectsFromArray:dean.classPbArray.copy];
    }
    return classes.copy;
}

- (uint64_t)fetchCurrentClassID {
    __block uint64_t class_id = 0;
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        //老师
        TeacherPb *teacher = self.currentUser.teacherPb;
        NSArray <MEPBClass*>*classes = teacher.classPbArray.copy;
        //目前策略直接取第一个class
        MEPBClass *cls = classes.firstObject;
        class_id = cls.id_p;
    } else if (self.currentUser.userType == MEPBUserRole_Parent) {
        //家长
        ParentsPb *parent = self.currentUser.parentsPb;
        NSArray<StudentPb*>*studdents = parent.studentPbArray.copy;
        uint64_t currentStudnetID = parent.cutStudenId;
        [studdents enumerateObjectsUsingBlock:^(StudentPb * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.id_p == currentStudnetID) {
                class_id = obj.classId;
            }
        }];
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        //园务
        DeanPb *dean = self.currentUser.deanPb;
        NSArray <MEPBClass*>*classes = dean.classPbArray.copy;
        //目前策略直接取第一个class
        MEPBClass *cls = classes.firstObject;
        class_id = cls.id_p;
    }
    return class_id;
}

#pragma mark --- initiazlized subviews

- (void)__initLiveRoomSubviews {
    //是否是老师
    self.whetherTeacherRole = (self.currentUser.userType == MEPBUserRole_Teacher && !self.currentUser.isTourist);
    
    //当前用户是否已绑定class
    BOOL didRelatedClass = [self whetherCurrentUserDidRelatedClass];
    if (!didRelatedClass) {
        self.emptyTitle = ME_EMPTY_PROMPT_TITLE;
        self.emptyDesc = PBFormat(@"您还没有与任何班级关联，请先关联班级！");
        self.whetherDidLoadData = true;
        [self.table reloadEmptyDataSet];
        return;
    }
    //当前用户所关联的所有班级
    NSArray<MEPBClass*>*classes = [self fetchMulticastClasses];
    self.classes = [NSArray arrayWithArray:classes];
}

#pragma mark --- fetch network data

/**
 预处理多个班级的情况
 */
- (void)preDealWithMulticastClasses {
    if (self.classes.count == 0) {
        self.emptyTitle = ME_EMPTY_PROMPT_TITLE;
        self.emptyDesc = PBFormat(@"您还没有与任何班级关联，请先关联班级！");
        self.whetherDidLoadData = true;
        [self.table reloadEmptyDataSet];
        return;
    }
    //TODO:弹框让用户选择班级
    
}

- (void)loadLiveClassRoomData {
    //当前class_id
    uint64_t class_id = [self fetchCurrentClassID];
    MELiveClassVM *vm = [[MELiveClassVM alloc] init];
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:class_id];
    weakify(self)
    [vm postData:[live data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBClassLive *liveRoom = [MEPBClassLive parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
        } else {
            self.dataLive = liveRoom;
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
    }];
}

- (void)rebuildLiveRoomSubviews {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
