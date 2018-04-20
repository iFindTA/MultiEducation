//
//  MEBabySelectProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabySelectProfile.h"
#import "MEBabySelectCell.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEBabySelectProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <StudentPb *> *babys;

@end

@implementation MEBabySelectProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

- (void)loadData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.babys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEBabySelectCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    
    [cell setData: [self.babys objectAtIndex: indexPath.row]];
    
    return cell;
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib: [UINib nibWithNibName: @"MEBabySelectCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

- (NSArray<StudentPb *> *)babys {
    if (!_babys) {
        _babys = self.currentUser.parentsPb.studentPbArray;
    }
    return _babys;
}


@end
