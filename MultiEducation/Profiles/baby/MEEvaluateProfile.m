//
//  MEEvaluateProfile.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEEvaluateProfile.h"
#import "MEEvaluateCell.h"

@interface MEEvaluateProfile () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MEEvaluateProfile

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableView *)tableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = YES;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    return tableView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MEEvaluateCell";
    MEEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MEEvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


@end
