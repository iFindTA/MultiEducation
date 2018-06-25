//
//  MENurseryProfile.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENurseryProfile.h"
#import "MENurseryCell.h"
#import "MENurseryVM.h"
#import <MJRefresh.h>

static NSString * const cellIdef = @"cell_idef";
static CGFloat const cellHeight = 54.f;

@interface MENurseryProfile () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *search;
@property (nonatomic, strong) MEBaseButton *cancelBtn;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *schoolArr;
@property (nonatomic, assign) int page;

@end

@implementation MENurseryProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = true;
    [self customSubviews];
    [self loadNurseryData];
}

- (void)customSubviews {
    MEBaseScene *naviBar = [[MEBaseScene alloc] initWithFrame: CGRectZero];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: naviBar];
    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
    }];
    
    self.cancelBtn = [[MEBaseButton alloc] init];
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    self.cancelBtn.titleLabel.font = UIFontPingFangSC(14);
    [self.cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
    [self.cancelBtn setTitleColor: UIColorFromRGB(0x999999) forState: UIControlStateNormal];
    [self.cancelBtn addTarget:self action: @selector(popStack) forControlEvents: UIControlEventTouchUpInside];
    [naviBar addSubview: self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(naviBar).mas_offset(-15.f);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR);
        make.top.mas_equalTo(self.navigationBar.mas_top).mas_offset([MEKits statusBarHeight]);
    }];
    
    MEBaseImageView *leftView = [[MEBaseImageView alloc] initWithFrame: CGRectMake(0, 0, 16, 16)];
    leftView.image = [UIImage imageNamed: @"search_bar_magnifier"];
    
    self.search = [[UITextField alloc] init];
    self.search.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.search.placeholder = @"搜索幼儿园";
    self.search.font = UIFontPingFangSC(14);
    self.search.textColor = UIColorFromRGB(0x333333);
    self.search.leftView = leftView;
    self.search.leftViewMode = UITextFieldViewModeAlways;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: self.search.placeholder attributes: @{NSForegroundColorAttributeName: UIColorFromRGB(0x999999), NSFontAttributeName: UIFontPingFangSC(14)}];
    self.search.attributedPlaceholder = attStr;
    [naviBar addSubview: self.search];
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(naviBar).mas_offset(14.f);
        make.right.mas_equalTo(self.cancelBtn.mas_left);
        make.centerY.mas_equalTo(self.cancelBtn);
        make.height.mas_equalTo(30.f);
    }];
    self.search.layer.cornerRadius = 15.f;
    self.search.layer.masksToBounds = true;
    
    MEBaseScene *sepView = [[MEBaseScene alloc] init];
    sepView.backgroundColor = UIColorFromRGB(0xF3F3F3);
    [naviBar addSubview: sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(naviBar);
        make.height.mas_equalTo(1.f);
    }];
    
    _table = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor whiteColor];
    _table.tableFooterView = [UIView new];
    _table.scrollEnabled = false;
    _table.separatorColor = UIColorFromRGB(0xF3F3F3);
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table registerNib: [UINib nibWithNibName: @"MENurseryCell" bundle: nil] forCellReuseIdentifier: cellIdef];
    [self.view addSubview: self.table];
}

- (void)loadNurseryData {
    SchoolAddressPb *pb = [[SchoolAddressPb alloc] init];
    MENurseryVM *vm = [MENurseryVM vmWithPB: pb];
    weakify(self);
    [vm postData: [pb data] pageSize: 20 pageIndex: _page hudEnable: true success:^(NSData * _Nullable resObj, int32_t totalPages) {
        strongify(self);
        NSError *err = [[NSError alloc] init];
        SchoolAddressListPb *pb = [SchoolAddressListPb parseFromData: resObj error: &err];
        if (err) {
            [MEKits handleError: err];
            return;
        }
        [self.schoolArr addObjectsFromArray: pb.schoolListArray];
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)popStack {
    [self.navigationController popViewControllerAnimated: true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schoolArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MENurseryCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdef forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: false];
    
    
}


#pragma mark - lazyloading
- (NSMutableArray *)schoolArr {
    if (!_schoolArr) {
        _schoolArr = [NSMutableArray array];
    }
    return _schoolArr;
}

@end
