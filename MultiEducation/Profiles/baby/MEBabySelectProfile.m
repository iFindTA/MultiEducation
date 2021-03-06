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
#import "Meuser.pbobjc.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 54.f;

@interface MEBabySelectProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <StudentPb *> *babys;

@end

@implementation MEBabySelectProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _selectBabyCallBack = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"切换儿童"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
#if TARGET_INTELLIGENT
    UIBarButtonItem *addStuItem = [MEKits barWithTitle: @"添加宝宝" color: [UIColor whiteColor] target: self action: @selector(pushToAddChildProfile)];
    item.rightBarButtonItem = addStuItem;
#endif
    [self.view addSubview: self.tableView];
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo([MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR);
    }];
}

- (void)pushToAddChildProfile {
    NSString *urlStr = @"profile://root@MEAddChildProfile";
    weakify(self);
    void(^didAddChildSuccessCallback) (void) = ^ (void) {
        strongify(self);
        self.babys = self.currentUser.parentsPb.studentPbArray;
        [self.tableView reloadData];
    };
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK: didAddChildSuccessCallback};
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sendSwitchBabyPostToServer:(StudentPb *)studentPb {
    MEStudentVM *vm = [MEStudentVM vmWithPb: studentPb];
    NSData *data = [studentPb data];
    [vm postData: data hudEnable: YES success:^(NSData * _Nullable resObj) {
        [self.navigationController popViewControllerAnimated: YES];
        if (self.selectBabyCallBack) {
            self.selectBabyCallBack(studentPb);
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
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
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
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
