//
//  MESelectFolderProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESelectFolderProfile.h"
#import "MEFolderCell.h"
#import "MEFolderPatchVM.h"

static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 65.f;

@interface MESelectFolderProfile () <UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ClassAlbumPb *> *dataArr;
@property (nonatomic, strong) NSArray <ClassAlbumPb *> * folders;

@end

@implementation MESelectFolderProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        [self.dataArr addObjectsFromArray: [params objectForKey: @"albums"]];
        self.folders = [params objectForKey: @"folders"];
        self.moveSuccCallback = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview: self.tableView];
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset([MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR);
    }];
    
    [self customNavigation];
}

- (void)customNavigation {
    NSString *title = @"移动到";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    navigationItem.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem: navigationItem animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEFolderCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    [cell setData: [self.folders objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassAlbumListPb *listPb = [[ClassAlbumListPb alloc] init];
    MEFolderPatchVM *vm = [MEFolderPatchVM vmWithPb: listPb];
    
    for (ClassAlbumPb *pb in self.dataArr) {
        pb.parentId = [self.folders objectAtIndex: indexPath.row].id_p;
        [listPb.classAlbumArray addObject: pb];
    }
    
    [vm postData: [listPb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        [self.navigationController popViewControllerAnimated: YES];
        if (self.moveSuccCallback) {
            self.moveSuccCallback();
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
    
}

#pragma mark - lazyloading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib: [UINib nibWithNibName: @"MEFolderCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
