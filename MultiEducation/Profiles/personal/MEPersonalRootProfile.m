//
//  MEPersonalRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRootProfile.h"
#import "MEGrowRecordProfile.h"
#import "MEPersonalHeader.h"
#import "MEHistoryVideo.h"
#import "MEPersonalSectionHeader.h"
#import "MEPersonalCell.h"

#define PERSONAL_TEXT_ARRAY @[@"我的收藏", @"客户服务", @"账户安全", @"帮助中心", @"反馈"]

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
    

    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(MESCREEN_HEIGHT - ME_HEIGHT_TABBAR);
    }];
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
    NSLog(@"did selected at indexPath.row:%ld", indexPath.row);
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
        _tableHeader = [[MEBaseScene alloc] initWithFrame: CGRectMake(0, 0, MESCREEN_WIDTH, HEADER_HEIGHT + HISTORY_HEIGHT)];
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
        
        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
        
        self.header = [[NSBundle mainBundle] loadNibNamed: @"MEPersonalHeader" owner: self options: nil].firstObject;
        [self.tableHeader addSubview: self.header];
        [self.tableHeader addSubview: self.historyVideo];
        
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
