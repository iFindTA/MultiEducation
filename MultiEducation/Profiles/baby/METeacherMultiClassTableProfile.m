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

@interface METeacherMultiClassTableProfile () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <MEPBClass *> *classes;

@end

@implementation METeacherMultiClassTableProfile

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
    uint64_t classId = [self.classes objectAtIndex: indexPath.row].id_p;
    NSDictionary *params = @{@"classId": [NSNumber numberWithUnsignedLongLong: classId], @"title": @"宝宝相册"};
    NSString *urlString = @"profile://root@MEBabyPhotoProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [self handleTransitionError:err];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
        _tableView.tableFooterView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
