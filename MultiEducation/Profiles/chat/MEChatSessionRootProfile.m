//
//  MEChatSessionRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEChatProfile.h"
#import "MEBaseProfile.h"
#import "MEChatSessionRootProfile.h"

@interface MEChatSessionRootProfile ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PBNavigationBar *navigationBar;

@end

@implementation MEChatSessionRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置聊天列表基础属性
    [self setupCustomRongIMUIs];
    
    //custom navigationBar
    [self.view addSubview:self.navigationBar];
    [self.conversationListTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *cotactItem = [MEKits barWithTitle:@"通讯录" color:[UIColor whiteColor] target:self action:@selector(userDidTouchContactTouchEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"聊天"];
    item.rightBarButtonItems = @[spacer, cotactItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PBMAIN(^{
        [self refreshConversationTableViewIfNeeded];
        [self.app updateRongIMUnReadMessageCounts];
    })
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Custom RongIM UI

- (void)setupCustomRongIMUIs {
    //是否显示网络状态
    self.isShowNetworkIndicatorView = YES;
    //是否显示连接状态
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置默认的聊天列表类型（是一个数组 数组中放着强转NSNumber类型的会话类型）
    //例如：ConversationType_PRIVATE 单聊
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM),
                                        @(ConversationType_APPSERVICE)]];
    // 把很多群组放在一个列表的一行cell里  把很多的讨论组放在一个列表的一行cell里
    [self setCollectionConversationType:@[@(ConversationType_GROUP),
                                          @(ConversationType_DISCUSSION)]];
    //设置cell的背景颜色
    self.cellBackgroundColor = [UIColor whiteColor];
    //设置置顶的cell的背景颜色
    self.topCellBackgroundColor = [UIColor whiteColor];
}

#pragma mark --- lazy loader

- (PBNavigationBar *)navigationBar {
    if (!_navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(0xFFFFFF);
        UIColor *barTintColor = pbColorMake(ME_THEME_COLOR_VALUE);//影响背景
        UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(0xE8E8E8)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        //adjust frame
        CGFloat height = [naviBar barHeight];
        barBounds = CGRectMake(0, 0, MESCREEN_WIDTH, height);
        [naviBar setFrame:barBounds];
        _navigationBar = naviBar;
    }
    
    return _navigationBar;
}

- (AppDelegate *)app {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark --- User Interface Actions

- (void)userDidTouchContactTouchEvent {
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEContactProfile" initMethod:nil params:nil instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:nil];
    [MEKits handleError:err];
}

#pragma mark --- User Chat Session Callback

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    MEChatProfile *chatPro = [[MEChatProfile alloc] init];
    chatPro.conversationType = model.conversationType;
    chatPro.targetId = model.targetId;
    chatPro.title = model.conversationTitle;
    chatPro.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatPro animated:YES];
    
}

@end
