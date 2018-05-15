//
//  MEContactProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import "MEChatProfile.h"
#import "MEClassChatVM.h"
#import "MEContactCell.h"
#import "MESearchPanel.h"
#import "Meclass.pbobjc.h"
#import "MEClassMemberVM.h"
#import <YCXMenu/YCXMenu.h>
#import "MEContactProfile.h"
#import <MJRefresh/MJRefresh.h>
#import "MEBaseNavigationProfile.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define ME_CONTACT_MAP_KEY_VALUE                            @"value"
#define ME_CONTACT_MAP_KEY_TITLE                            @"title"
#define ME_CONTACT_MAP_KEY_ICON                             @"icon"

@interface MEContactProfile () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <YCXMenuItem*> *menuItems;

/**
 列表数据源, 班级列表数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MEBaseTableView *table;
@property (nonatomic, assign) BOOL whetherDidLoadData;

#pragma mark --- UI Components
@property (nonatomic, strong) MESearchPanel *searchPanel;
@property (nonatomic, strong) MASConstraint *searchBarTopConstraint, *searchHeightConstraint;

/**
 空信息提示
 */
@property (nonatomic, copy, nullable) NSString *emptyTitle, *emptyDescription;

@property (nonatomic, strong, nullable) MEPBClass *currentClass;
@property (nonatomic, strong, nullable) NSArray<MEPBClass*>*classes;
@property (nonatomic, strong, nullable) NSArray <YCXMenuItem *> *classItems;


@end

@implementation MEContactProfile

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
    
    //UIImage *moreImage = [UIImage imageNamed:@"chat_contact_add"];
    UIColor *backColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self color:backColor];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"班级通讯录"];
    item.leftBarButtonItems = @[spacer, backItem];
    BOOL whetherMultiClasses = [MEKits whetherCurrentUserHaveMulticastClasses];
    if (whetherMultiClasses) {
        UIBarButtonItem *moreItem = [MEKits barWithUnicode:@"\U0000e6dc" title:nil color:backColor target:self action:@selector(exchangeClassTouchEvent)];
        item.rightBarButtonItems = @[spacer, moreItem];
    }
    [self.navigationBar pushNavigationItem:item animated:true];
    
    //search panel
    [self.view insertSubview:self.searchPanel belowSubview:self.navigationBar];
    //NSUInteger shrinkHeight = ME_LAYOUT_SUBBAR_HEIGHT;
    NSUInteger expandHeight = ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight];
    [self.searchPanel makeConstraints:^(MASConstraintMaker *make) {
        /*make.top.equalTo(self.view).offset(expandHeight).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchBarTopConstraint) {
            self.searchBarTopConstraint = make.top.equalTo(self.view).priority(UILayoutPriorityRequired);;
        }
        make.left.right.equalTo(self.view);
        make.height.equalTo(shrinkHeight).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchHeightConstraint) {
            self.searchHeightConstraint = make.height.equalTo(expandHeight).priority(UILayoutPriorityRequired);
        }//*/
        //先不显示搜索
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(expandHeight);
    }];
    [self.searchBarTopConstraint deactivate];
    [self.searchHeightConstraint deactivate];
    weakify(self)
    self.searchPanel.searchPanelFirstResponder = ^(BOOL first){
        strongify(self)
        [self updateSearchAndNavigationBarConstraints:first];
    };
    
    //table
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.searchPanel.mas_bottom);
    }];
    //down pull to refresh
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self refreshCurrentClassContacs];
    }];
    
    self.whetherDidLoadData = false;
}

- (void)updateSearchAndNavigationBarConstraints:(BOOL)first {
    first?[self.searchBarTopConstraint activate]:[self.searchBarTopConstraint deactivate];
    first?[self.searchHeightConstraint activate]:[self.searchHeightConstraint deactivate];
    [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataSource.count == 0 && !self.whetherDidLoadData) {
        [self prepareClassContactsInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy loading

- (NSArray<YCXMenuItem*>*)menuItems {
    if (!_menuItems) {
        NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
        UIColor *iconColor = [UIColor whiteColor];
        NSString *title = @"发起群聊";
        UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e618" withSize:iconSize withColor:iconColor];
        YCXMenuItem *chatItem = [YCXMenuItem menuItem:title image:img target:self action:@selector(userDidTouchLanuchGroupChatEvent)];
        img = [UIImage pb_iconFont:nil withName:@"\U0000e62d" withSize:iconSize withColor:iconColor];
        title = @"扫一扫";
        YCXMenuItem *scanItem = [YCXMenuItem menuItem:title image:img target:self action:@selector(userDidTouchQRCodeScanEvent)];
        _menuItems = [NSArray arrayWithObjects:chatItem, scanItem, nil];
    }
    return _menuItems;
}

- (NSArray<YCXMenuItem*>*)classItems {
    if (!_classItems) {
        NSArray <MEPBClass*>*classes = [MEKits fetchCurrentUserMultiClasses];
        NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
        UIColor *iconColor = [UIColor whiteColor];
        __block NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        [classes enumerateObjectsUsingBlock:^(MEPBClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj.name;
            YCXMenuItem *item = [YCXMenuItem menuItem:title image:nil target:self action:@selector(userDidTouchClass:)];
            item.tag = idx;
            [items addObject:item];
        }];
        _classItems = [NSArray arrayWithArray:items.copy];
    }
    return _classItems;
}

- (MESearchPanel *)searchPanel {
    if (!_searchPanel) {
        _searchPanel = [[MESearchPanel alloc] initWithFrame:CGRectZero];
    }
    return _searchPanel;
}

- (MEBaseTableView *)table {
    if (!_table) {
        _table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark --- User Interface Touch Events

- (void)navigationBarMoreTouchEvent {
    NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
    CGRect bounds = CGRectMake(MESCREEN_WIDTH-iconSize-ME_LAYOUT_MARGIN*2, ME_HEIGHT_NAVIGATIONBAR+ME_LAYOUT_MARGIN, iconSize, iconSize);
    [YCXMenu showMenuInView:self.view fromRect:bounds menuItems:self.menuItems selected:^(NSInteger index, YCXMenuItem *item) {
        
    }];
}

/**
 扫一扫
 */
- (void)userDidTouchQRCodeScanEvent {
    [YCXMenu dismissMenu];
    NSString *urlString = @"profile://root@MEQRScanProfile";
    NSError *err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    [MEKits handleError:err];
}

/**
 发起群聊
 */
- (void)userDidTouchLanuchGroupChatEvent {
    [YCXMenu dismissMenu];
}

/**
 切换班级
 */
- (void)exchangeClassTouchEvent {
    NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
    CGRect bounds = CGRectMake(MESCREEN_WIDTH-iconSize-ME_LAYOUT_MARGIN*2, ME_HEIGHT_NAVIGATIONBAR+ME_LAYOUT_MARGIN, iconSize, iconSize);
    [YCXMenu showMenuInView:self.view fromRect:bounds menuItems:self.classItems selected:^(NSInteger index, YCXMenuItem *item) {
        
    }];
}

- (void)userDidTouchClass:(YCXMenuItem *)item {
    [YCXMenu dismissMenu];
    [self userDidSelectClass4Contact:item.title];
}

#pragma mark --- DZNEmpty DataSource & Deleagte

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataSource.count == 0 && self.whetherDidLoadData;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *imgColor =UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *image = [UIImage pb_iconFont:nil withName:ME_ICONFONT_EMPTY_HOLDER withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_TITLE;
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.emptyDescription;
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

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self prepareClassContactsInfo];
}

#pragma mark --- UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return section;
    }
    return ME_LAYOUT_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    CGRect bounds = (CGRect){.origin = CGPointZero, .size = CGSizeMake(MESCREEN_WIDTH, ME_LAYOUT_MARGIN)};
    MEBaseScene *scene = [[MEBaseScene alloc] initWithFrame:bounds];
    scene.backgroundColor = UIColorFromRGB(0xF3F3F3);
    return scene;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionMap = self.dataSource[section];
    NSArray *sectionSets = [sectionMap pb_arrayForKey:ME_CONTACT_MAP_KEY_VALUE];
    return sectionSets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ME_HEIGHT_TABBAR - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactCell";
    MEContactCell *cell = (MEContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MEContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //index for row/section
    NSUInteger __row = [indexPath row];NSUInteger __section = [indexPath section];
    NSDictionary *sectionMap = self.dataSource[__section];
    if (__row == 0) {
        NSString *title = [sectionMap pb_stringForKey:ME_CONTACT_MAP_KEY_TITLE];
        cell.sectionLab.text = PBAvailableString(title);
    } else {
        cell.sectionLab.hidden = true;
    }
    //value array
    NSArray *sectionSets = [sectionMap pb_arrayForKey:ME_CONTACT_MAP_KEY_VALUE];
    if (__section == 0) {
        NSDictionary *infoMap = [sectionSets objectAtIndex:__row];
        NSString *title = [infoMap pb_stringForKey:ME_CONTACT_MAP_KEY_TITLE];
        cell.infoLab.text = PBAvailableString(title);
        NSString *iconString = [infoMap pb_stringForKey:ME_CONTACT_MAP_KEY_ICON];
        UIImage *image = [UIImage imageNamed:iconString];
        cell.icon.image = image;
    } else {
        MEClassMember *member = [sectionSets objectAtIndex:__row];
        cell.infoLab.text = PBAvailableString(member.name);
        UIImage *placehodler = [UIImage imageNamed:@"appicon_placeholder"];
        NSString *iconString = member.portrait;
        NSURL *iconUrl = [NSURL URLWithString:PBAvailableString(iconString)];
        [cell.icon sd_setImageWithURL:iconUrl placeholderImage:placehodler];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //index for row/section
    NSUInteger __row = [indexPath row];NSUInteger __section = [indexPath section];
    if (__section == 0) {
        if (__row == 0) {
            //班聊
            [self userDidTouchClassChatEvent];
        }
    } else {
        NSDictionary *sectionMap = self.dataSource[__section];
        //class members
        NSArray *sectionSets = [sectionMap pb_arrayForKey:ME_CONTACT_MAP_KEY_VALUE];
        MEClassMember *member = [sectionSets objectAtIndex:__row];
        //班级成员
        NSDictionary *params = @{@"member":member, @"classTitle":PBAvailableString(self.currentClass.name)};
        NSString *routeString = @"profile://root@MEContactInfoProfile";
        NSError *err = [MEDispatcher openURL:[NSURL URLWithString:routeString] withParams:params];
        [MEKits handleError:err];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark --- Load Data increasment

/**
 预处理班级信息
 */
- (void)prepareClassContactsInfo {
    NSArray<MEPBClass*>*classes = [MEKits fetchCurrentUserMultiClasses];
    if (classes.count == 0) {
        self.whetherDidLoadData = true;
        self.emptyTitle = ME_EMPTY_PROMPT_TITLE;
        self.emptyDescription = ME_ALERT_INFO_NONE_CLASS;
        [self.table reloadEmptyDataSet];
    } else if (classes.count == 1) {
        self.currentClass = classes.firstObject;
        [self loadClassContacts];
    } else {
        self.classes = classes;
        weakify(self)
        [self makeUserSelectMulticastClassesWhetherGobackOnCancel:true completion:^(NSString *clsName) {
            if (clsName.length > 0) {
                strongify(self)
                [self userDidSelectClass4Contact:clsName];
            }
        }];
    }
}

- (void)makeUserSelectMulticastClassesWhetherGobackOnCancel:(BOOL)back completion:(void(^_Nullable)(NSString * clsName))completion {
    NSArray <MEPBClass*>*classes = self.classes;
    if (classes.count <= 1) {
        return;
    }
    UIAlertController *alertProfile = [UIAlertController alertControllerWithTitle:@"选择班级" message:@"您关联了多个班级，请选择其中一个！" preferredStyle:UIAlertControllerStyleActionSheet];
    for (MEPBClass *cls in classes) {
        NSString *clsName = PBAvailableString(cls.name);
        UIAlertAction *action = [UIAlertAction actionWithTitle:clsName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(action.title);
            }
        }];
        [alertProfile addAction:action];
    }
    weakify(self)
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (back) {
            strongify(self)
            [self defaultGoBackStack];
        }
    }];
    [alertProfile addAction:action];
    
    [self presentViewController:alertProfile animated:true completion:^{
        
    }];
}

- (void)userDidSelectClass4Contact:(NSString *)clsName {
    if (self.currentClass != nil) {
        //如果已有当前class 说明是切换class
        [self.dataSource removeAllObjects];
        self.whetherDidLoadData = false;
        [self.table reloadEmptyDataSet];
        [self.table reloadData];
    }
    for (MEPBClass *cls in self.classes) {
        if ([cls.name isEqualToString:clsName]) {
            self.currentClass = cls;
            break;
        }
    }
    if (self.currentClass.name.length > 0) {
        //更新navigationBar title
        NSString *classTitle = PBAvailableString(self.currentClass.name);
        NSString *itemTitle = PBFormat(@"%@通讯录", classTitle);
        NSArray<UINavigationItem*>*items = self.navigationBar.items;
        [items enumerateObjectsUsingBlock:^(UINavigationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.title = itemTitle;
        }];
    }
    //查询本地数据
    //再次获取更新之后的数组
    NSArray<MEClassMember*>*members = [MEClassMemberVM fetchClassMembers4ClassID:self.currentClass.id_p];
    if (members.count == 0) {
        [self.table.mj_header beginRefreshing];
    } else {
        //[SVProgressHUD showInfoWithStatus:@"请稍后..."];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        alert.hideAnimationType = SCLAlertViewShowAnimationFadeIn;
        [alert showWaiting:@"处理中..." subTitle:nil closeButtonTitle:nil duration:1];
        [self prepareHandleClassMembers:members];
    }
}

/**
 下拉刷新 班级成员列表
 */
- (void)refreshCurrentClassContacs {
    if (!self.currentClass) {
        [self.table.mj_header endRefreshing];
        [SVProgressHUD showInfoWithStatus:ME_ALERT_INFO_NONE_CLASS];
        return;
    }
    //状态重置
    //[self.dataSource removeAllObjects];
    self.whetherDidLoadData = false;
    [self.table reloadEmptyDataSet];
    [self.table reloadData];
    
    [self loadClassContacts];
}

/**
 此处真正开始加载联系人数据
 1，先从本地加载
 2，再从网络刷新
 */
- (void)loadClassContacts {
    
    //old timestamp
    int64_t timestamp = [MEClassMemberVM fetchMaxTimestamp4ClassID:self.currentClass.id_p];
    MEClassMemberVM *vm = [[MEClassMemberVM alloc] init];
    MEClassMemberList *list = [[MEClassMemberList alloc] init];
    [list setTimestamp:timestamp];
    [list setClassIds:PBFormat(@"%lld", self.currentClass.id_p)];
    weakify(self)
    [vm postData:[list data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEClassMemberList *memberList = [MEClassMemberList parseFromData:resObj error:&err];
        //NSLog(@"timestamp:%lld", memberList.timestamp);
        if (err) {
            [MEKits handleError:err];
        } else {
            [self handleCurrentClassMembers:memberList];
        }
        [self.table.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [MEKits handleError:error];
        [self.table.mj_header endRefreshing];
    }];
}

- (void)handleCurrentClassMembers:(MEClassMemberList*)list {
    if (list.classUserArray.count > 0) {
        NSArray<MEClassMember*>*members = list.classUserArray.copy;
        [MEClassMemberVM saveClassMembers:members];
    }
    self.whetherDidLoadData = true;
    //再次获取更新之后的数组
    NSArray<MEClassMember*>*members = [MEClassMemberVM fetchClassMembers4ClassID:self.currentClass.id_p];
    [self prepareHandleClassMembers:members];
}

/**
 排序 插入班聊
 */
- (void)prepareHandleClassMembers:(NSArray<MEClassMember*>*)members {
    if (members.count > 0) {
        NSArray *sortSets = [self sortObjectsAccordingToInitialWith:members];
        NSDictionary *classChatMap = [self generateClassRelativeDatas];
        [self.dataSource removeAllObjects];
        [self.dataSource addObject:classChatMap];
        [self.dataSource addObjectsFromArray:sortSets];
        [self.table reloadEmptyDataSet];
        [self.table reloadData];
    } else {
        self.emptyDescription = @"该班级还没有成员！";
        [self.table reloadData];
        [self.dataSource removeAllObjects];
        [self.table reloadEmptyDataSet];
    }
}

// 按首字母分组排序数组
-(NSArray *)sortObjectsAccordingToInitialWith:(NSArray<MEClassMember*>*)arr {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (MEClassMember *m in arr) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:m collationStringSelector:@selector(name)];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:m];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //去空
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray<MEClassMember*>*members = (NSMutableArray*)(newSectionsArray[index]);
        if (members.count != 0) {
            MEClassMember *firstMember = members.firstObject;
            NSString *indexAscii = [firstMember.name pb_zhHansName2Ascii4Type:PBZHHans2AsciiTypeLastChar];
            [finalArr addObject:@{ME_CONTACT_MAP_KEY_TITLE:indexAscii, ME_CONTACT_MAP_KEY_VALUE:members.copy}];
        }
    }
    return finalArr;
}

/**
 生成班级相关的数据
 */
- (NSDictionary *)generateClassRelativeDatas {
    NSMutableArray *classItems = [NSMutableArray arrayWithCapacity:0];
    //如果角色是老师 或者园务 则可以看到教师组
    MEPBUserRole role = self.currentUser.userType;
    BOOL whetherHaveTeacherClass = (role & (MEPBUserRole_Teacher|MEPBUserRole_Gardener));
    if (whetherHaveTeacherClass) {
        //[self.classDataSource addObject:@"教师组"];
        
    }
    //此版本先放一个组
    NSDictionary *iconMap = @{ME_CONTACT_MAP_KEY_ICON:@"contact_icon_class_group", ME_CONTACT_MAP_KEY_TITLE:@"班聊"};
    [classItems addObject:iconMap];
    NSDictionary *classMap = [NSDictionary dictionaryWithObjectsAndKeys:classItems.copy, ME_CONTACT_MAP_KEY_VALUE, @"#", ME_CONTACT_MAP_KEY_TITLE, nil];
    return classMap;
}

#pragma mark --- 班聊事件

- (void)userDidTouchClassChatEvent {
    if (!self.currentClass) {
        return;
    }
    
    //获取本地数据
    NSArray<MECSession*>*sessions = [MEClassChatVM fetchClassChatSessions4ClassID:self.currentClass.id_p];
    if (sessions.count > 0) {
        [self handleClassSessionList:sessions];
    } else {
        int64_t timestamp = [MEClassChatVM fetchMaxClassSessionTimestamp4ClassID:self.currentClass.id_p];
        //发起班聊
        MEClassChatVM *vm = [[MEClassChatVM alloc] init];
        MECSession *cSession = [[MECSession alloc] init];
        cSession.timestamp = timestamp;
        cSession.classId = self.currentClass.id_p;
        weakify(self)
        [vm postData:[cSession data] hudEnable:true success:^(NSData * _Nullable resObj) {
            NSError *err; strongify(self)
            MESessionList *sessionList = [MESessionList parseFromData:resObj error:&err];
            if (err) {
                [MEKits handleError:err];
            } else {
                [self handleClassSessionList:sessionList.classSessionArray.copy];
                [MEClassChatVM saveClassChatSessions:sessionList.classSessionArray.copy];
            }
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError:error];
        }];
    }
}

- (void)handleClassSessionList:(NSArray<MECSession*>*)cSessions {
    MECSession *destSession;
    for (MECSession *s in cSessions) {
        if (s.classId == self.currentClass.id_p) {
            destSession = s;
            break;
        }
    }
    if (!destSession) {
        [SVProgressHUD showErrorWithStatus:@"当前班级班聊无法开启！"];
        return;
    }
    NSString *targetID = PBFormat(@"CLASS-%lld", destSession.id_p);
    MEChatProfile *chatProfile = [[MEChatProfile alloc] initWithConversationType:ConversationType_GROUP targetId:targetID];
    chatProfile.title = PBAvailableString(destSession.name);
    chatProfile.hidesBottomBarWhenPushed = true;
    [self.appDelegate.winProfile pushViewController:chatProfile animated:true];
    
//    NSArray<UIViewController*>*stacks = [self.navigationController viewControllers];
//    NSMutableArray<UIViewController*>*newStacks = [NSMutableArray arrayWithCapacity:0];
//    for (UIViewController *profile in stacks) {
//        if ([profile isKindOfClass:[self class]] || [profile isMemberOfClass:[self class]]) {
//            break;
//        } else {
//            [newStacks addObject:profile];
//        }
//    }
//    [newStacks addObject:chatProfile];
//    [self.navigationController setViewControllers:newStacks.copy animated:true];
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
