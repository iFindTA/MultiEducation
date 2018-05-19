//
//  MEMultiSelectBabyProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMultiSelectBabyProfile.h"
#import "MEMultiBabyCell.h"
#import <YUChineseSorting/ChineseString.h>

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 48.f;

@interface MEMultiSelectBabyProfile () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *letterIndexArr;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation MEMultiSelectBabyProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if(self) {
        NSArray *selectedArr = [params objectForKey: @"selectedBabys"];
        [self.dataArr addObjectsFromArray: selectedArr];
    }
    return self;
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"选择用户"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)loadData {
    
    NSArray *nameArr = @[@"张三", @"李四", @"王五", @"网六", @"钱塘江", @"金克斯", @"科加斯", @"鬼脚七", @"dr.c", @"古拉加斯"];

    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject: nameArr[i] forKey: @"name"];
        [dic setObject: [UIImage imageNamed: @"appicon_placeholder"] forKey: @"portrait"];
        [tmpArr addObject: dic];
    }
    
    self.letterIndexArr = [ChineseString IndexArray: nameArr];
    
    NSArray *sortedArr = [ChineseString LetterSortArray: nameArr];
    
    [self.dataArr addObjectsFromArray: sortedArr];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    [self.view addSubview: self.tableView];
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
    }];
    [self loadData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.results.count;
    } else {
        return ((NSArray *)[self.dataArr objectAtIndex: section]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEMultiBabyCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    if (self.searchController.active) {
        cell.nameLab.text = [self.results objectAtIndex: indexPath.row];
    } else {
        cell.nameLab.text = [[self.dataArr objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: false];
    
    MEMultiBabyCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.selBtn.selected = !cell.selBtn.selected;
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.results != nil) {
        [self.results removeAllObjects];
    }
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSArray *arr in self.dataArr) {
        [tmpArr addObjectsFromArray: [NSMutableArray arrayWithArray:[arr filteredArrayUsingPredicate:preicate]]];
    }
    [self.results addObjectsFromArray: tmpArr];

    [self.tableView reloadData];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = UIColorFromRGB(0xF8F8F8);
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib: [UINib nibWithNibName: @"MEMultiBabyCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)letterIndexArr {
    if (!_letterIndexArr) {
        _letterIndexArr = [NSMutableArray array];
    }
    return _letterIndexArr;
}

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        // 设置结果更新代理
        _searchController.searchResultsUpdater = self;
        // 因为在当前控制器展示结果, 所以不需要这个透明视图
        _searchController.dimsBackgroundDuringPresentation = NO;
        // 将searchBar赋值给tableView的tableHeaderView
        self.tableView.tableHeaderView = _searchController.searchBar;
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        // To change background color
        searchField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _searchController;
}


@end
