//
//  MEChatSessionRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEChatSessionRootProfile.h"

@interface MEChatSessionRootProfile ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MEChatSessionRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置聊天列表基础属性
    [self setRongIMProperty];
    
    [self layoutChileViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRongIMProperty {
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

- (void)layoutChileViews {
    self.title = @"聊天";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleToAddressbookItem)];
    [barButtonItem setTitle:@"通讯录"];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

#pragma mark --- 点击Cell回调 ---
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"进入回话界面");
}

#pragma mark --- Handle Action ---
- (void)handleToAddressbookItem {
    NSLog(@"点击通讯录...");
}

@end
