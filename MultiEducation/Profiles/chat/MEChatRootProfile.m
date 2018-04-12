//
//  MEChatRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEChatRootProfile.h"
#import "ChatCtrl.h"
#import "FscContactsCtrl.h"

@interface MEChatRootProfile ()
{
    UIView *_navigationView;
}

@end

@implementation MEChatRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _navigationView = [self navigationView];
    
    //设置消息类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    [self setIsShowNetworkIndicatorView:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshConversationTableViewIfNeeded];
}


- (UIView *)navigationView {
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [self.view addSubview:navigationView];
    weakify(self);
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.right);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"聊天";
    titleLabel.textColor = [UIColor pb_colorWithHexString:@"ffffff"];
    titleLabel.font = UIFontPingFangSC(METHEME_FONT_NAVIGATION);
    [titleLabel sizeToFit];
    [navigationView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navigationView.mas_centerX);
        make.bottom.equalTo(navigationView.bottom).with.offset( - (44 - METHEME_FONT_NAVIGATION) / 2);
    }];
    
    UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBookBtn setTitle:@"通讯录" forState:UIControlStateNormal];
    [addressBookBtn setTitleColor:[UIColor pb_colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    addressBookBtn.titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
    [navigationView addSubview:addressBookBtn];
    [addressBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.right.equalTo(navigationView.right).with.offset(-15);
    }];
    
    return navigationView;
}

- (void)addressBookClick:(UIButton *)btn {
    FscContactsCtrl *addressBook = [[FscContactsCtrl alloc] init];
    [self.navigationController pushViewController:addressBook animated:YES];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatCtrl *conversationVC = [[ChatCtrl alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
