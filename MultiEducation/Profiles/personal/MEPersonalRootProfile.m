//
//  MEPersonalRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRootProfile.h"
#import "MEPersonalHeader.h"
#import "MEHistoryVideo.h"
#import "MEPersonalSectionHeader.h"
#import "MEPersonalCell.h"
#import <WHC_ModelSqlite.h>
#import "MEWatchItem.h"


#define PERSONAL_TEXT_ARRAY @[@"我的收藏", @"客户服务", @"账户管理", @"帮助中心", @"反馈", @"关于我们"]

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 44.f;
static CGFloat const HEADER_HEIGHT = 170.f;
static CGFloat const HISTORY_HEIGHT = 155.f;
static CGFloat const SECTION_HEADER = 56.f;

@interface MEPersonalRootProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MEPersonalHeader *header; //header
@property (nonatomic, strong) MEHistoryVideo *historyVideo; //history video

@property (nonatomic, strong) MEBaseScene *tableHeader; //tableHeader for MEPersonalHeader + MEHistoryVideo, in order to the whole page can scroll
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
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-ME_HEIGHT_TABBAR);
    }];
}

- (BOOL)whetherHistoryCountGreaterThanZero {
    NSString *where = [NSString stringWithFormat: @"userId = %lld", self.currentUser.id_p];
    if ([WHCSqlite query: [MEWatchItem class] where: where order: @"by watchTimestamp desc"].count > 0 ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)pushToPersonSecondProfileWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {
            NSString *urlStr = @"profile://root@MECollectionProfile";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [self handleTransitionError: error];
        }
            break;
        case 1: {
            //contact_us.html
            NSString *urlStr = @"profile://root@METemplateProfile";
            NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"联系我们", ME_CORDOVA_KEY_STARTPAGE:@"contact_us.html"};
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
            [self handleTransitionError: error];
        }
            break;
            
        case 2: {
            NSString *urlStr = @"profile://root@MEAccountSafeProfile/";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [self handleTransitionError: error];
        }
            break;
            
        case 3: {
            
        }
            break;
            
        case 4: {
            
        }
            break;
        case 5: {
            NSString *urlStr = @"profile://root@MEAboutMeProfile/";
            NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
            [self handleTransitionError: error];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[MEPersonalSectionHeader alloc] initWithFrame: CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEADER;
}

#pragma mark - lazyloading
- (MEHistoryVideo *)historyVideo {
    if (!_historyVideo) {
        _historyVideo = [[MEHistoryVideo alloc] init];
    }
    return _historyVideo;
}

- (MEBaseScene *)tableHeader {
    if (!_tableHeader) {
        CGFloat tableHeaderHeight;
        if ([self whetherHistoryCountGreaterThanZero]) {
            tableHeaderHeight = HEADER_HEIGHT + HISTORY_HEIGHT;
        } else {
            tableHeaderHeight = HEADER_HEIGHT;
        }
        _tableHeader = [[MEBaseScene alloc] initWithFrame: CGRectMake(0, 0, MESCREEN_WIDTH, tableHeaderHeight)];
        _tableHeader.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeader;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
        
        self.header = [[NSBundle mainBundle] loadNibNamed: @"MEPersonalHeader" owner: self options: nil].firstObject;
        
        [self.tableHeader addSubview: self.header];
        
        //layout
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.tableHeader);
            make.width.mas_equalTo(MESCREEN_WIDTH);
            make.height.mas_equalTo(HEADER_HEIGHT);
        }];
        
        if ([self whetherHistoryCountGreaterThanZero]) {
            [self.tableHeader addSubview: self.historyVideo];
            
            [self.historyVideo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.tableHeader);
                make.top.mas_equalTo(self.header.mas_bottom);
                make.width.mas_equalTo(MESCREEN_WIDTH);
                make.height.mas_equalTo(HISTORY_HEIGHT);
            }];
        }

        _tableView.tableHeaderView = self.tableHeader;

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
