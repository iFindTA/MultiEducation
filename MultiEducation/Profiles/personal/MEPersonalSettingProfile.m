//
//  MEPersonalSettingProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPersonalSettingProfile.h"
#import "MEPersonalDataCell.h"
#import "MEHeaderIconCell.h"

#define TITLE_LIST @[@"头像管理", @"昵称", @"手机号", @"性别"]

static NSString * const USER_ICON_CELL_IDEF = @"user_icon_cell_idef";
static NSString * const USER_DATA_CELL_IDEF = @"user_data_cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEPersonalSettingProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation MEPersonalSettingProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation];
    
    [self.view addSubview: self.tableView];
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_NAVIGATIONBAR + ME_HEIGHT_STATUSBAR);
    }];
}

- (void)customNavigation {
    NSString *title = @"个人资料";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MEHeaderIconCell *cell = [tableView dequeueReusableCellWithIdentifier: USER_ICON_CELL_IDEF forIndexPath: indexPath];
        cell.textLab.text = [TITLE_LIST objectAtIndex: indexPath.row];
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.currentUser.portrait];
        [cell.headIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
        return cell;
    } else {
        MEPersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier: USER_DATA_CELL_IDEF forIndexPath: indexPath];
        cell.titleLab.text = [TITLE_LIST objectAtIndex: indexPath.row];
        switch (indexPath.row) {
            case 1:
                cell.subtitleLab.text = self.currentUser.username;
                break;
            case 2:
                cell.subtitleLab.text = self.currentUser.mobile;
                break;
            case 3: {
                NSString *gender;
                if (self.currentUser.gender == 1) {
                    gender = @"男";
                } else {
                    gender = @"女";
                }
                cell.subtitleLab.text = gender;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];

        [_tableView registerNib: [UINib nibWithNibName: @"MEHeaderIconCell" bundle: nil] forCellReuseIdentifier: USER_ICON_CELL_IDEF];
        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalDataCell" bundle: nil] forCellReuseIdentifier: USER_DATA_CELL_IDEF];
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = TITLE_LIST;
    }
    return _dataArr;
}

@end
