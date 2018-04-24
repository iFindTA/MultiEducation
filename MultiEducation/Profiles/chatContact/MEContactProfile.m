//
//  MEContactProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import "MEContactCell.h"
#import "MESearchPanel.h"
#import "Meclass.pbobjc.h"
#import <YCXMenu/YCXMenu.h>
#import "MEContactProfile.h"
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
    UIBarButtonItem *backItem = [MEKits backBarWithColor:backColor target:self withSelector:@selector(defaultGoBackStack)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"班级通讯录"];
    item.leftBarButtonItems = @[spacer, backItem];
    BOOL whetherMultiClasses = [MEKits whetherCurrentUserHaveMulticastClasses];
    if (whetherMultiClasses) {
        UIBarButtonItem *moreItem = [MEKits barWithIconUnicode:@"\U0000e7d7" color:backColor target:self eventSelector:@selector(exchangeClassTouchEvent)];
        item.rightBarButtonItems = @[spacer, moreItem];
    }
    [self.navigationBar pushNavigationItem:item animated:true];
    
    //search panel
    [self.view addSubview:self.searchPanel];
    NSUInteger shrinkHeight = ME_LAYOUT_SUBBAR_HEIGHT;
    NSUInteger expandHeight = ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight];
    [self.searchPanel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(expandHeight).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchBarTopConstraint) {
            self.searchBarTopConstraint = make.top.equalTo(self.view).priority(UILayoutPriorityRequired);;
        }
        make.left.right.equalTo(self.view);
        make.height.equalTo(shrinkHeight).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchHeightConstraint) {
            self.searchHeightConstraint = make.height.equalTo(expandHeight).priority(UILayoutPriorityRequired);
        }
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (!self.whetherDidLoadData || self.dataSource.count == 0) {
        [self prepareClassContactsInfo];
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
    [YCXMenu showMenuInView:self.view fromRect:bounds menuItems:self.menuItems selected:^(NSInteger index, YCXMenuItem *item) {
        
    }];
}

- (void)userDidTouchClass:(YCXMenuItem *)item {
    
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
    [self loadContactsFromServerOnline];
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
    NSArray *sectionSets = [sectionMap pb_arrayForKey:ME_CONTACT_MAP_KEY_VALUE];
    if (__row == 0) {
        NSString *title = [sectionMap pb_stringForKey:ME_CONTACT_MAP_KEY_TITLE];
        cell.sectionLab.text = PBAvailableString(title);
    } else {
        cell.sectionLab.hidden = true;
    }
    NSDictionary *infoMap = [sectionSets objectAtIndex:__row];
    NSString *title = [infoMap pb_stringForKey:ME_CONTACT_MAP_KEY_TITLE];
    cell.infoLab.text = PBAvailableString(title);
    NSString *iconString = [infoMap pb_stringForKey:ME_CONTACT_MAP_KEY_ICON];
    if (__section == 0) {
        UIImage *image = [UIImage imageNamed:iconString];
        cell.icon.image = image;
    } else {
        UIImage *placehodler = [UIImage imageNamed:@"appicon_placeholder"];
        NSURL *iconUrl = [NSURL URLWithString:PBAvailableString(iconString)];
        [cell.icon sd_setImageWithURL:iconUrl placeholderImage:placehodler];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //index for row/section
    NSUInteger __row = [indexPath row];NSUInteger __section = [indexPath section];
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
        [self makeUserChooseMulticastClasses];
    }
}

/**
 让用户选择班级
 */
- (void)makeUserChooseMulticastClasses {
    NSArray <MEPBClass*>*classes = self.classes;
    if (classes.count <= 1) {
        return;
    }
    UIAlertController *alertProfile = [UIAlertController alertControllerWithTitle:@"选择班级" message:@"您关联了多个班级，请选择一个进行查看！" preferredStyle:UIAlertControllerStyleActionSheet];
    weakify(self)
    for (MEPBClass *cls in classes) {
        NSString *clsName = PBAvailableString(cls.name);
        UIAlertAction *action = [UIAlertAction actionWithTitle:clsName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            strongify(self)
            [self userDidSelectClass4Contact:action.title];
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

- (void)userDidSelectClass4Contact:(NSString *)clsName {
    for (MEPBClass *cls in self.classes) {
        if ([cls.name isEqualToString:clsName]) {
            self.currentClass = cls;
            break;
        }
    }
    [self loadClassContacts];
}

/**
 此处真正开始加载联系人数据
 1，先从本地加载
 2，再从网络刷新
 */
- (void)loadClassContacts {
    //先清空之前数据
    [self.dataSource removeAllObjects];
    self.whetherDidLoadData = false;
    [self.table reloadEmptyDataSet];
    [self.table reloadData];
    
    
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

/**
 加载在线通讯录
 */
- (void)loadContactsFromServerOnline {
    
    
    //插入班级相关数据
    NSDictionary *classItem = [self generateClassRelativeDatas];
    [self.dataSource insertObject:classItem atIndex:0];
    
    [self.table reloadData];
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
