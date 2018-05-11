//
//  MEPersonalRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRootProfile.h"
#import "MEPersonalHeader.h"
#import "MEPersonalCell.h"
#import <WHC_ModelSqlite.h>
#import "MEWatchItem.h"
#import "MEChatProfile.h"
#import "MEBaseNavigationProfile.h"
#import "UIView+Frame.h"

#define PERSONAL_TEXT_ARRAY @[@"我的收藏", @"客户服务", @"帮助中心", @"反馈", @"关于我们"]

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 54.f;
static CGFloat const HEADER_HEIGHT = 170.f;

@interface MEPersonalRootProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MEPersonalRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview: self.tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(MESCREEN_HEIGHT - ME_HEIGHT_TABBAR - [MEKits statusBarHeight] - ME_HEIGHT_NAVIGATIONBAR);
        make.top.mas_equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)pushToPersonSecondProfileWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            NSString *urlStr = @"profile://root@MECollectionProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [MEKits handleError: error];
        }
            break;
        case 1: {
            //contact_us.html
            NSString *urlStr = @"profile://root@METemplateProfile";
            NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"联系我们", ME_CORDOVA_KEY_STARTPAGE:@"contact_us.html"};
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
            [MEKits handleError: error];
        }
            break;
        case 2: {
            //help.html#/help
            NSString *urlStr = @"profile://root@METemplateProfile";
            NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"帮助中心", ME_CORDOVA_KEY_STARTPAGE:@"help.html#/help"};
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
            [MEKits handleError: error];
        }
            break;
            
        case 3: {
            //反馈接入融云
            MEChatProfile *profile = [[MEChatProfile alloc] initWithConversationType:ConversationType_APPSERVICE targetId:@"SYS_XDY"];
            profile.title = PBAvailableString([NSBundle pb_displayName]);
            profile.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:profile animated:true];
        }
            break;
        case 4: {
            NSString *urlStr = @"profile://root@MEAboutMeProfile/";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [MEKits handleError: error];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return HEADER_HEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
     MEBaseScene *tableHeader = [[MEBaseScene alloc] initWithFrame: CGRectMake(0, 0, MESCREEN_WIDTH, HEADER_HEIGHT)];
    MEPersonalHeader *header = [[NSBundle mainBundle] loadNibNamed: @"MEPersonalHeader" owner: self options: nil].firstObject;
    [tableHeader addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(tableHeader);
    }];
    return tableHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MEPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    [cell setData: [self.dataArr objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    [self pushToPersonSecondProfileWithIndex: indexPath.row];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.separatorColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];

    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithArray: PERSONAL_TEXT_ARRAY];
    }
    return _dataArr;
}

@end
