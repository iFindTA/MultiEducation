//
//  MELiveRoomRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveClassVM.h"
#import <MJRefresh/MJRefresh.h>
#import "MEIndexStoryItemCell.h"
#import "MELiveRoomRootProfile.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

/**
 * 头部播放高度
 */
static NSUInteger ME_LIVE_PLAY_SCENE_HEIGHT                             =   200;

@interface MELiveRoomRootProfile () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

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

@property (nonatomic, strong) MEBaseButton *startLiveBtn;
@property (nonatomic, strong) MEBaseScene *liveScene;
@property (nonatomic, strong) MEBaseLabel *liveMaskLab;

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
    
    //live scene
    [self.view addSubview:self.liveScene];
    [self.liveScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(adoptValue(ME_LIVE_PLAY_SCENE_HEIGHT));
    }];
    //mask
    [self.liveScene addSubview:self.liveMaskLab];
    [self.liveMaskLab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.liveScene);
    }];
    
    //title
    MEBaseScene *scene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    scene.backgroundColor = [UIColor pb_randomColor];
    [self.view addSubview:scene];
    [scene makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.liveScene.mas_bottom);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    label.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    label.text = @"往期视频";
    [scene addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scene).insets(UIEdgeInsetsMake(0, ME_LAYOUT_MARGIN*2, 0, ME_LAYOUT_MARGIN*2));
    }];
    
    // add table
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //add live button
    NSUInteger liveBtnSize = ME_HEIGHT_TABBAR;
    [self.view addSubview:self.startLiveBtn];
    [self.startLiveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
        make.size.equalTo(CGSizeMake(liveBtnSize, liveBtnSize));
    }];
    
    self.whetherDidLoadData = false;
    
    [self __initLiveRoomSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (!self.currentClass && !self.whetherDidLoadData) {
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

- (MEBaseScene *)liveScene {
    if (!_liveScene) {
        _liveScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _liveScene.backgroundColor = [UIColor pb_randomColor];
    }
    return _liveScene;
}

- (MEBaseLabel *)liveMaskLab {
    if (!_liveMaskLab) {
        _liveMaskLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _liveMaskLab.textAlignment = NSTextAlignmentCenter;
        _liveMaskLab.font = UIFontPingFangSCMedium(METHEME_FONT_LARGETITLE);
        _liveMaskLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
        _liveMaskLab.text = @"当前没有老师开播！";
        _liveMaskLab.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _liveMaskLab;
}

- (MEBaseTableView *)table {
    if (!_table) {
        _table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

- (MEBaseButton *)startLiveBtn {
    if (!_startLiveBtn) {
        UIImage *image = [UIImage imageNamed:@"live_class_preStart"];
        _startLiveBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [_startLiveBtn setImage:image forState:UIControlStateNormal];
        [_startLiveBtn addTarget:self action:@selector(startLiveRoomTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startLiveBtn;
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

#pragma mark --- UITableView Deleagte & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger counts = self.dataLive.recorderListArray.count;
    NSUInteger rows = counts / ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    if (counts % ME_INDEX_STORY_ITEM_NUMBER_PER_LINE != 0) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger __row = [indexPath row];
    CGFloat row_height = ME_INDEX_STORY_ITEM_HEIGHT;
    if (__row == 0) {
        row_height = ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT;
    }
    return adoptValue(row_height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"live_lubo_item_cell";
    MEIndexStoryItemCell *cell = (MEIndexStoryItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MEIndexStoryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger __row = [indexPath row];
    NSArray<MEPBClassLive*>*classItems = self.dataLive.recorderListArray.copy;
    NSUInteger allCounts = classItems.count;
    [cell configureStoryItem4RowIndex:__row];
    //item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    for (int i = 0; i < numPerLine; i ++) {
        NSUInteger real_item_index = __row * numPerLine + i;
        if (real_item_index < allCounts) {
            MEPBClassLive *res = classItems[real_item_index];
            NSString *title = res.title.copy;
            (i % numPerLine == 0)?[cell.leftItemLabel setText:title]:[cell.rightItemLabel setText:title];
            (i % numPerLine == 0)?[cell.leftItemScene setTag:real_item_index]:[cell.rightItemScene setTag:real_item_index];
            
            NSString *imgUrl = [MEKits imageFullPath:res.coverImg];
            UIImage *image = [UIImage imageNamed:@"index_content_placeholder"];
            if (i % numPerLine == 0) {
                [cell.leftItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            } else {
                [cell.rightItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            }
        } else {
            cell.rightItemScene.hidden = true;
        }
    }
    //callback
    weakify(self)
    cell.indexContentItemCallback = ^(NSUInteger section, NSUInteger index){
        strongify(self)
        [self subClassesStoryItemDidTouchRowIndex:index];
    };
    
    return cell;
}

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
    } else if (self.classes.count == 1) {
        self.currentClass = self.classes.firstObject;
        [self loadLiveClassRoomData];
    }
    //有多个班级 弹框让用户选择班级
    PBMAINDelay(ME_ANIMATION_DURATION, ^{
        [self makeUserChooseClasses];
    });
}

/**
 让用户选择班级
 */
- (void)makeUserChooseClasses {
    NSArray <MEPBClass*>*classes = self.classes.copy;
    if (classes.count <= 1) {
        return;
    }
    UIAlertController *alertProfile = [UIAlertController alertControllerWithTitle:@"选择班级" message:@"您关联了多个班级，请选择一个进行查看！" preferredStyle:UIAlertControllerStyleActionSheet];
    weakify(self)
    for (MEPBClass *cls in classes) {
        NSString *clsName = PBAvailableString(cls.name);
        UIAlertAction *action = [UIAlertAction actionWithTitle:clsName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            strongify(self)
            [self userDidChooseClass4Name:action.title];
        }];
        [alertProfile addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        strongify(self)
        [self defaultGoBackStack];
    }];
    [alertProfile addAction:action];
    
    [self presentViewController:alertProfile animated:true completion:^{
        
    }];
}

/**
 用户选择了某一个班级 则拉取数据
 */
- (void)userDidChooseClass4Name:(NSString *)clsName {
    for (MEPBClass *cls in self.classes) {
        if ([cls.name isEqualToString:clsName]) {
            self.currentClass = cls;
            break;
        }
    }
    [self loadLiveClassRoomData];
}

- (void)loadLiveClassRoomData {
    if (!self.currentClass) {
        NSLog(@"还未选择班级class!");
        return;
    }
    //当前class_id
    uint64_t class_id = self.currentClass.id_p;
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
        [self rebuildLiveRoomSubviews];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
        self.emptyTitle = ME_EMPTY_PROMPT_TITLE;
        self.emptyDesc = ME_EMPTY_PROMPT_DESC;
        self.whetherDidLoadData = true;
        [self.table reloadEmptyDataSet];
    }];
}

/**
 依据用户角色不同 创建不同用户界面
 */
- (void)rebuildLiveRoomSubviews {
    self.whetherDidLoadData = true;
    
    
}

#pragma mark --- User Interface Action

- (void)startLiveRoomTouchEvent {
    
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
