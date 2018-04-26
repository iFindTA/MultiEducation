//
//  MEAccountSafeProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAccountSafeProfile.h"
#import "MEPersonalCell.h"

#define TEXT_ARR @[@"修改密码", @"退出登录"]

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEAccountSafeProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation MEAccountSafeProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation];
    
    self.array = TEXT_ARR;
    
    [self.view addSubview: self.tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

- (void)customNavigation {
    NSString *title = @"账户安全";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool: YES] forKey: ME_USER_DID_INITIATIVE_LOGOUT];
    [self.appDelegate updateCurrentSignedInUser:nil];
    [self splash2ChangeDisplayStyle: MEDisplayStyleAuthor];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    BOOL hide;
    if (indexPath.row == 1) {
        hide = YES;
    } else {
        hide = NO;
    }
    [cell setData:  [self.array objectAtIndex: indexPath.row] hidden: hide];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    if (indexPath.row == 0) {
        NSString *urlStr = @"profile://root@MEUpdatePasswordProfile";
        NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
        [self handleTransitionError: error];
    } else {
        [self logout];
    }
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

        [_tableView registerNib: [UINib nibWithNibName: @"MEPersonalCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

@end
