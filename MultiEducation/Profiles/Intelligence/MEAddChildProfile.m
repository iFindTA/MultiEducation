//
//  MEAddChildProfile.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAddChildProfile.h"
#import "MEPersonalDataCell.h"

static CGFloat const cellHeight = 54;
static CGFloat const sectionHeaderHeight = 54;
static NSString * const cellIdef = @"cell_idef";

@interface MEAddChildProfile () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray <NSArray *> *titles;


@end

@implementation MEAddChildProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
    [self customNavigation];
}

- (void)customNavigation {
    NSString *title = @"添加孩子";
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: title];
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    self.navigationItem.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles objectAtIndex: section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEPersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdef forIndexPath: indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEBaseScene *view = [[MEBaseScene alloc] init];
    view.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
    return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath: indexPath animated: false];
}

#pragma mark - lazyloading
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@[@"孩子姓名", @"性别", @"生日"], @[@"与宝宝关系", @"幼儿园"]];
    }
    return _titles;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = [UIColor whiteColor];
        _table.tableFooterView = [UIView new];
        _table.scrollEnabled = false;
        _table.separatorColor = UIColorFromRGB(0xF3F3F3);
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_table registerNib: [UINib nibWithNibName: @"MEPersonalDataCell" bundle: nil] forCellReuseIdentifier: cellIdef];
    }
    return _table;
}

@end
