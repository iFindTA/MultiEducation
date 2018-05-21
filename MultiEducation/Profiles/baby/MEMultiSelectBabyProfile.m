//
//  MEMultiSelectBabyProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMultiSelectBabyProfile.h"
#import "MEMultiBabyCell.h"
#import <YUChineseSorting/ChineseString.h>
#import "MEStudentModel.h"
#import "Mestudent.pbobjc.h"
#import "Meclass.pbobjc.h"
#import "MEBabyIndexVM.h"
#import "MEStudentListVM.h"


static NSString * const CELL_IDEF = @"cell_idef";
static CGFloat const CELL_HEIGHT = 48.f;

@interface MEMultiSelectBabyProfile () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (nonatomic, assign) int64_t semester;
@property (nonatomic, assign) int64_t classId;
@property (nonatomic, assign) int64_t gradeId;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <MEStudentModel *> *selectedArr;
@property (nonatomic, strong) NSMutableArray <NSArray <MEStudentModel *> *> *dataArr;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray <MEStudentModel *> *results;
@end

@implementation MEMultiSelectBabyProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if(self) {
        self.didSelectedStuCallback = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
        self.semester = [[params objectForKey: @"semester"] longLongValue];
        self.classId = [[params objectForKey: @"classId"] longLongValue];
        self.gradeId = [[params objectForKey: @"gradeId"] longLongValue];
        self.selectedArr = [params objectForKey: @"selectedBabys"];
    }
    return self;
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"选择用户"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    item.rightBarButtonItem = [MEKits barWithTitle: @"确定" color: [UIColor whiteColor] target: self action: @selector(didConfirmButtonItemTouchEvent)];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)didConfirmButtonItemTouchEvent {
    NSMutableArray *selectedStuArr = [NSMutableArray array];
    for (NSArray *arr in self.dataArr) {
        for (MEStudentModel *stu in arr) {
            if (stu.status == Selected) {
                [selectedStuArr addObject: stu];
            }
        }
    }
    if (self.didSelectedStuCallback) {
        self.didSelectedStuCallback(selectedStuArr);
    }
    [self.navigationController popViewControllerAnimated: true];
}

- (void)loadData {
    weakify(self)
    MEStudent *s = [[MEStudent alloc] init];
    s.type = 6;
    s.classId = _classId;
    s.gradeId = _gradeId;
    s.semester = _semester;
    s.month = [MEBabyIndexVM fetchSelectBaby].month;
    MEStudentListVM *vm = [[MEStudentListVM alloc] init];
    [vm postData:[s data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEStudentList *list = [MEStudentList parseFromData:resObj error:&err];
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (MEStudent *stu in list.studentsArray) {
            MEStudentModel *model = [[MEStudentModel alloc] init];
            model.name = stu.name;
            model.portrait = stu.portrait;
            model.stuId = stu.id_p;
            if (stu.status == 1) {
                //已完成
                model.status = CantSelect;
            }
            if (stu.status == 0) {
                //未填写
                for (MEStudentModel *stuModel in self.selectedArr) {
                    if (stuModel.stuId == model.stuId) {
                        model.status = Selected;
                        break;
                    } else {
                        model.status = Unselected;;
                    }
                }
            }
            model.letter = [MEKits getFirstLetterFromString: model.name];
            [tmpArr addObject: model];
        }
    
        NSMutableArray *nameArr = [NSMutableArray array];
        for (MEStudentModel *stu in tmpArr) {
            [nameArr addObject: stu.name];
        }
        NSArray *indexArr = [ChineseString IndexArray: nameArr];
        for (NSString *letter in indexArr) {
            NSMutableArray *letterArr = [NSMutableArray array];
            for (MEStudentModel *stu in tmpArr) {
                if ([letter isEqualToString: stu.letter]) {
                    [letterArr addObject: stu];
                }
            }
            [self.dataArr addObject: letterArr];
        }
        [self.tableView reloadData];

        if (err) {
            [MEKits handleError:err];
            return ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}


//- (void)loadData {
//    //for test
//    NSArray *nameArr = @[@"张三", @"李四", @"王五", @"网六", @"钱塘江", @"金克斯", @"科加斯", @"鬼脚七", @"drc", @"古拉加斯", @"古德包哎", @"李四", @"王五", @"网六", @"钱塘江", @"金克斯", @"科加斯", @"鬼脚七", @"drc", @"古拉加斯", @"古德包哎", @"李四", @"王五", @"网六", @"钱塘江", @"金克斯", @"科加斯", @"鬼脚七", @"drc", @"古拉加斯", @"古德包哎"];
//
//    NSMutableArray *tmpArr = [NSMutableArray array];
//    for (int i = 0; i < nameArr.count; i++) {
//        MEStudent *stu = [[MEStudent alloc] init];
//        stu.name = [nameArr objectAtIndex: i];
//        [tmpArr addObject: stu];
//    }
//
//    NSMutableArray *realNameArr = [NSMutableArray array];
//    for (StudentPb *pb in tmpArr) {
//        [realNameArr addObject: pb.name];
//    }
//
//    NSArray *sortedArr = [ChineseString LetterSortArray: realNameArr];
//    for (NSArray *arr in sortedArr) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSString *str in arr) {
//            for (StudentPb *pb in tmpArr) {
//                if ([pb.name isEqualToString: str]) {
//                    MEStudentModel *stu = [[MEStudentModel alloc] init];
//                    stu.name = str;
//                    int a = arc4random() % 3;
//                    stu.status = 1 << a;
//                    [array addObject: stu];
//                    stu.letter = [MEKits getFirstLetterFromString: stu.name];
//                }
//            }
//        }
//        [self.dataArr addObject: array];
//    }
//    [self.tableView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    [self.view addSubview: self.tableView];
    //layout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
    }];
    [self loadData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.results.count;
    } else {
        return ((NSArray *)[self.dataArr objectAtIndex: section]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEMultiBabyCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_IDEF forIndexPath: indexPath];
    if (self.searchController.active) {
        MEStudentModel *model = [self.results objectAtIndex: indexPath.row];
        cell.nameLab.text = model.name;
        [cell setData: model];
    } else {
        MEStudentModel *model = [[self.dataArr objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
        if (indexPath.row == 0) {
            cell.searchLab.text = model.letter;
            cell.searchLab.hidden = false;
        } else {
            cell.searchLab.text = @"";
            cell.searchLab.hidden = true;
        }
        cell.nameLab.text = model.name;
        [cell setData: model];

    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xF3F3F3);
        return view;
    } else {
        return [UIView new];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: false];
    MEStudentModel *model;
    if (_searchController.active) {
        model = [self.results objectAtIndex: indexPath.row];
    } else {
        model = [[self.dataArr objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    }
    
    if (model.status == CantSelect) {
        return;
    } else {
        if (_searchController.active) {
            if (model.status == Selected) {
                model.status = Unselected;
            } else {
                model.status = Selected;
            }
        } else {
            if (model.status == Selected) {
                model.status = Unselected;
            } else {
                model.status = Selected;
            }
        }
        
    }
    [self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //FIXME: preicate 语句有问题，array里是MEStudentModel，不是NSString
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS [c] %@", searchString];

    for (NSArray *arr in self.dataArr) {
        [self.results addObjectsFromArray: [arr filteredArrayUsingPredicate: predicate]];
    }

    [self.tableView reloadData];
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = UIColorFromRGB(0xF8F8F8);
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib: [UINib nibWithNibName: @"MEMultiBabyCell" bundle: nil] forCellReuseIdentifier: CELL_IDEF];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        // 设置结果更新代理
        _searchController.searchResultsUpdater = self;
        // 因为在当前控制器展示结果, 所以不需要这个透明视图
        _searchController.dimsBackgroundDuringPresentation = false;
        // 将searchBar赋值给tableView的tableHeaderView
        self.tableView.tableHeaderView = _searchController.searchBar;
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        // To change background color
        searchField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _searchController;
}


@end
