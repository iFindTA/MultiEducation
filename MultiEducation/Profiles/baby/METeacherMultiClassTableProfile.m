//
//  METeacherMultiClassTableProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METeacherMultiClassTableProfile.h"
#import "Meclass.pbobjc.h"
#import "MEBabyPhotoProfile.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 44.f;

@interface METeacherMultiClassTableProfile () <UITableViewDelegate, UITableViewDataSource> {
    NSString *_pushUrlStr;
    NSString *_title;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <MEPBClass *> *classes;

@end

@implementation METeacherMultiClassTableProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _pushUrlStr = [params objectForKey: @"pushUrlStr"];
        _title = [params objectForKey: @"title"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"选择班级"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    [self.view addSubview: self.tableView];

    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
        make.left.right.bottom.mas_equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  CELL_IDEF];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CELL_IDEF];
    }
    
    NSString *className = [self.classes objectAtIndex: indexPath.row].name;
    NSString *gradeName =[self.classes objectAtIndex: indexPath.row].gradeName;
    cell.textLabel.text = [NSString stringWithFormat: @"%@--%@", className, gradeName];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath  animated: YES];
    //埋点
    if ([_pushUrlStr isEqualToString: @"profile://root@MEBabyPhotoProfile/"]) {
        [MobClick event:Buried_CLASS_ALBUM];
    }
    MEPBClass *classPb = [self.classes objectAtIndex: indexPath.row];
    NSDictionary *params = @{@"classPb": classPb, @"title": _title};
    NSString *urlString = _pushUrlStr;
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
    }
    return _tableView;
}

- (NSArray *)classes {
    if (!_classes) {
        NSArray *arr;
        if (self.currentUser.userType == MEPBUserRole_Teacher) {
            arr = self.currentUser.teacherPb.classPbArray;
        } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
            arr = self.currentUser.deanPb.classPbArray;
        }
        _classes = [NSArray arrayWithArray: arr];
    }
    return _classes;
}


@end
