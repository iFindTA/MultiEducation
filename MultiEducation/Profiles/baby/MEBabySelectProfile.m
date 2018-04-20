//
//  MEBabySelectProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabySelectProfile.h"
#import "MEBabySelectCell.h"
#import "MEStudentVM.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEBabySelectProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <StudentPb *> *babys;

@end

@implementation MEBabySelectProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"切换儿童"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)sendSwitchBabyPostToServer:(StudentPb *)studenPb {
    MEStudentVM *vm = [MEStudentVM vmWithPb: studenPb];
    NSData *data = [studenPb data];
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        NSLog(@"切换成功");
    } failure:^(NSError * _Nonnull error) {
        [self handleTransitionError: error];
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self sendSwitchBabyPostToServer: [self.babys objectAtIndex: indexPath.row]];;
    if (self.selectBabyCallBack) {
        self.selectBabyCallBack([self.babys objectAtIndex: indexPath.row]);
    }
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
