//
//  MEBabySettingProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabySettingProfile.h"

static NSString * const USER_ICON_CELL_IDEF = @"user_icon_cell_idef";
static NSString * const USER_DATA_CELL_IDEF = @"user_data_cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEBabySettingProfile () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@end

@implementation MEBabySettingProfile

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


#pragma mark - lazyloading
- (UITableView *)table {
    if(!_table) {
        _table = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.tableFooterView = [UIView new];
        _table.separatorColor = UIColorFromRGB(0XF8F8F8);
        _table.dataSource = self;
        _table.delegate = self;
        [_table registerNib: [UINib nibWithNibName: @"MEHeaderIconCell" bundle: nil] forCellReuseIdentifier: USER_ICON_CELL_IDEF];
        [_table registerNib: [UINib nibWithNibName: @"MEPersonalDataCell" bundle: nil] forCellReuseIdentifier: USER_DATA_CELL_IDEF];
    }
    return _table;
}


@end
