//
//  MEPersonalRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRootProfile.h"
#import "MEPersonalListCell.h"
#import "MEPersonalVipCell.h"
#import "MEPersonalRecordCell.h"
#import "MEGrowRecordProfile.h"
#import "MEPersonalHeader.h"
#import "MEHistoryVideo.h"
#import "MEPersonalSectionHeader.h"

#define PERSONAL_TEXT_ARRAY @[@"我的收藏", @"客户服务", @"账户安全", @"帮助中心", @"反馈"]

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const ROW_HEIGHT = 44.f;
static CGFloat const HEADER_HEIGHT = 170.f;
static CGFloat const HISTORY_HEIGHT = 170.f;
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
    
    [self.tableHeader addSubview: self.header];
    [self.tableHeader addSubview: self.historyVideo];
    [self.view addSubview: self.tableView];
    
    //layout
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.tableHeader);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(HEADER_HEIGHT);
    }];
    
    [self.historyVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableHeader);
        make.top.mas_equalTo(self.header.mas_bottom);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(HISTORY_HEIGHT);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did selected at indexPath.row:%ld", indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[MEPersonalSectionHeader alloc] initWithFrame: CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEADER;
}

#pragma mark - lazyloading
- (MEPersonalHeader *)header {
    if (!_header) {
        _header = [[MEPersonalHeader alloc] init];
    }
    return _header;
}

- (MEHistoryVideo *)historyVideo {
    if (!_historyVideo) {
        _historyVideo = [[MEHistoryVideo alloc] init];
    }
    return _historyVideo;
}

- (MEBaseScene *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[MEBaseScene alloc] init];
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
        _tableView.tableHeaderView = self.tableHeader;
        
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
