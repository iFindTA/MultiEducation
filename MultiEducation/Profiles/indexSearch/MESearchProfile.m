//
//  MESearchProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoClassVM.h"
#import "MESearchProfile.h"
#import "MEIndexStoryItemCell.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MESearchProfile ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, assign) NSUInteger totalPages, currentPageIndex;
@property (nonatomic, assign) BOOL whetherDidLoadData;
@property (nonatomic, strong) NSMutableArray <MEPBRes*>*dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation MESearchProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = @"搜索结果";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
