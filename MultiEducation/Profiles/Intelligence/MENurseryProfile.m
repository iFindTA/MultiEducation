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
#import "Meclass.pbobjc.h"
#import "MENurseryClassVM.h"
#import <MJRefresh.h>

typedef NS_ENUM(NSUInteger ,SelectingType) {
    SelectingSchool =                                      1            << 0,   //当前正在选择学校
    SelectingClass =                                       1            << 1    //当前正在选择班级
};

static NSString * const cellIdef = @"cell_idef";
static CGFloat const cellHeight = 54.f;

@interface MENurseryProfile () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *search;
@property (nonatomic, strong) MEBaseButton *cancelBtn;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray <SchoolAddressPb *> *schoolArr;
@property (nonatomic, strong) NSMutableArray <MEPBClass *> *classArr;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int totalPages;

@property (nonatomic, assign) SelectingType type;

@property (nonatomic, strong) SchoolAddressPb *selectSchool;    //选中的学校
@property (nonatomic, strong) MEPBClass *selectClass;  //选中的班级

@end

@implementation MENurseryProfile

- (id)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        if (params) {
            self.didSelectSchoolCallback = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = SelectingSchool;
    self.navigationBar.hidden = true;
    [self customSubviews];
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
    self.search.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.search.delegate = self;
    [self.search addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    _table.separatorColor = UIColorFromRGB(0xF3F3F3);
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table registerClass: [MENurseryCell class] forCellReuseIdentifier: cellIdef];
    weakify(self);
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongify(self);
        self.page = 0;
        [self loadNurseryData: self.search.text];
        [self.table.mj_header endRefreshing];
    }];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        strongify(self)
        self.page++;
        [self loadNurseryData: self.search.text];
        [self.table.mj_footer endRefreshing];
    }];
    [self.view addSubview: self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(naviBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)textFieldDidChange:(id)sender {
    [self loadNurseryData: self.search.text];
}

- (void)loadNurseryData:(NSString *)text {
    SchoolAddressListPb *pb = [[SchoolAddressListPb alloc] init];
    pb.keyword = text;
    MENurseryVM *vm = [MENurseryVM vmWithPB: pb];
    if (self.totalPages != 0 && self.page >= self.totalPages) {
        return;
    }
    weakify(self);
    [vm postData: [pb data] pageSize: ME_PAGING_SIZE pageIndex: _page hudEnable: true success:^(NSData * _Nullable resObj, int32_t totalPages) {
        strongify(self);
        self.totalPages = totalPages;
        if (self.page == 0) {
            [self.schoolArr removeAllObjects];
        }
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

- (void)loadNurseryClassData {
    MEPBClass *classPb = [[MEPBClass alloc] init];
    classPb.schoolId = self.selectSchool.id_p;
    MENurseryClassVM *vm = [MENurseryClassVM vmWithPB: classPb];
    [vm postData: classPb.data hudEnable: true success:^(NSData * _Nullable resObj) {
        NSError *err = [[NSError alloc] init];
        MEPBClassList *classListPb = [MEPBClassList parseFromData: resObj error: &err];
        if (err) {
            [MEKits handleError: err];
            return;
        }
        [self.classArr addObjectsFromArray: classListPb.classPbArray];
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
    if (self.type == SelectingSchool) {
        return self.schoolArr.count;
    } else {
        return self.classArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MENurseryCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdef forIndexPath: indexPath];
    if (self.type == SelectingSchool) {
        [cell setData: [self.schoolArr objectAtIndex: indexPath.row]];
    } else {
        [cell setDataWithClass: [self.classArr objectAtIndex: indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: false];
    if (self.type == SelectingSchool) {
        self.type = SelectingClass;
        self.selectSchool = [self.schoolArr objectAtIndex: indexPath.row];
        self.search.text = @"";
        [self.schoolArr removeAllObjects];
        [self loadNurseryClassData];
        self.table.mj_header = nil;
        self.table.mj_footer = nil;
    } else {
        self.selectClass = [self.classArr objectAtIndex: indexPath.row];
        if (self.didSelectSchoolCallback) {
            [self.navigationController popViewControllerAnimated: true];
            self.didSelectSchoolCallback(self.selectSchool, self.selectClass);
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.type == SelectingSchool) {
        if ([string isEqualToString: @"\n"]) {
            return false;
        }
        NSString *searchText = [NSString stringWithFormat: @"%@%@", textField.text, string];
        [self loadNurseryData: searchText];
        return true;
    } else {
        return true;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - lazyloading
- (NSMutableArray *)schoolArr {
    if (!_schoolArr) {
        _schoolArr = [NSMutableArray array];
    }
    return _schoolArr;
}

- (NSMutableArray<MEPBClass *> *)classArr {
    if (!_classArr) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

@end
