//
//  MEAddChildProfile.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAddChildProfile.h"
#import "MEPersonalDataCell.h"
#import "METextFieldCell.h"
#import "MEActionCell.h"
#import "Meclass.pbobjc.h"
#import "MEAddChildVM.h"
#import "MEUserVM.h"
#import <ActionSheetPicker.h>

static CGFloat const cellHeight = 54;
static CGFloat const sectionHeaderHeight = 5;
static NSString * const selectCellIdef = @"select_cell_idef";
static NSString * const inputCellIdef = @"input_cell_idef";

@interface MEAddChildProfile () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray <NSArray *> *titles;

@property (nonatomic, strong) MEBaseButton *confirmBtn;

@property (nonatomic, strong) StudentPb *inputStu;

//更新内存中与数据库中的User用的
@property (nonatomic, strong) StudentPb *addStu;
@property (nonatomic, strong) MEPBClass *addClass;

@end

@implementation MEAddChildProfile

- (id)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.didAddChildSuccessCallback = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
    [self customNavigation];
    [self.view addSubview: self.table];
    CGFloat tableHeight = self.titles.count * sectionHeaderHeight + 5 * cellHeight;
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
        make.height.mas_equalTo(tableHeight);
    }];
}

- (void)customNavigation {
    NSString *title = @"添加孩子";
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: title];
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    self.navigationItem.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)userSelectGender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: @"选择性别" preferredStyle: UIAlertControllerStyleActionSheet];
    MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 1 inSection: 0]];
    weakify(self);
    UIAlertAction *dadAc = [UIAlertAction actionWithTitle:@"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [cell setSubtitleText: @"男"];
        self.inputStu.parentType = 1;
    }];
    UIAlertAction *momAc = [UIAlertAction actionWithTitle:@"女" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [cell setSubtitleText: @"女"];
        self.inputStu.parentType = 2;
    }];
    [alert addAction: dadAc];
    [alert addAction: momAc];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController: alert animated: true completion: nil];
}

- (void)userSelectBirthDay {
    MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:2 inSection: 0]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate date];
    if (![cell.subtitleLab.text isEqualToString: @"请选择"] && ![cell.subtitleLab.text isEqualToString: @"请输入"]) {
        date = [formatter dateFromString: cell.subtitleLab.text];
    }
    AppDelegate *delegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    weakify(self);
    [ActionSheetDatePicker showPickerWithTitle:@"选择生日" datePickerMode: UIDatePickerModeDate selectedDate: date minimumDate: [NSDate dateWithTimeIntervalSince1970: 0] maximumDate: [NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        strongify(self);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter stringFromDate: selectedDate];
        MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:2 inSection:0]];
        [cell setSubtitleText: dateStr];
        self.inputStu.birthday = [MEKits DateString2TimeStampWithFormatter:@"yyyy-MM-dd" dateStr: dateStr];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin: delegate.window];
}

- (void)userSelectRelationWithBaby {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: @"选择与宝宝关系" preferredStyle: UIAlertControllerStyleActionSheet];
    MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1]];
    weakify(self);
    UIAlertAction *dadAc = [UIAlertAction actionWithTitle:@"我是爸爸" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [cell setSubtitleText: @"我是爸爸"];
        self.inputStu.parentType = 1;
    }];
    UIAlertAction *momAc = [UIAlertAction actionWithTitle:@"我是妈妈" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [cell setSubtitleText: @"我是妈妈"];
        self.inputStu.parentType = 2;
    }];
    [alert addAction: dadAc];
    [alert addAction: momAc];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController: alert animated: true completion: nil];
}

- (void)userSelectNursery {
    weakify(self);
    void (^didSelectSchoollCallback) (SchoolPb *school, MEPBClass *cls) = ^(SchoolPb *school, MEPBClass *cls) {
        strongify(self);
        MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:4 inSection:0]];
        [cell setSubtitleText: [NSString stringWithFormat: @"%@%@%@", school.name, cls.gradeName, cls.name]];
        self.inputStu.schoolId = school.id_p;
        self.inputStu.classId = cls.id_p;
        self.inputStu.gradeId = cls.gradeId;
        self.addClass = cls;
    };
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK: didSelectSchoollCallback};
    NSString *urlStr = @"profile://root@MENurseryProfile";
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)sendAddChildMsgToServer {
    METextFieldCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *stuName = cell.input.text;
    self.inputStu.name = stuName;
    
    if ([self.inputStu.name isEqualToString: @""] || self.inputStu.name == nil) {
        [MEKits makeToast: @"请输入孩子姓名"];
        return;
    }
    
    if (self.inputStu.gender != 1 && self.inputStu.gender != 2) {
        [MEKits makeToast: @"请选择孩子性别"];
        return;
    }
    
    if (self.inputStu.birthday <= 0 ) {
        [MEKits makeToast: @"请选择孩子生日"];
        return;
    }
    
    if (self.inputStu.parentType != 1 && self.inputStu.parentType != 2) {
        [MEKits makeToast: @"请选择与宝宝关系"];
        return;
    }
    
    if (self.inputStu.schoolId == 0 || self.inputStu.gradeId == 0 || self.inputStu.classId == 0) {
        [MEKits makeToast: @"请选择幼儿园"];
        return;
    }
    
    MEAddChildVM *vm = [MEAddChildVM vmWithPB: self.inputStu];
    weakify(self);
    [vm postData: self.inputStu.data hudEnable: true success:^(NSData * _Nullable resObj) {
        strongify(self);
        self.addStu = self.inputStu;
        [MEUserVM updateUserStuent: self.addStu cls: self.addClass uid: self.currentUser.uid];
        [self.navigationController popViewControllerAnimated: true];
        if (self.didAddChildSuccessCallback) {
            self.didAddChildSuccessCallback();
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles objectAtIndex: section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        METextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier: inputCellIdef forIndexPath: indexPath];
        [cell updateLayout];
        cell.titleLab.text = self.titles[indexPath.section][indexPath.row];
        return cell;
    } else {
        MEPersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier: selectCellIdef forIndexPath: indexPath];
        cell.titleLab.text = self.titles[indexPath.section][indexPath.row];
        [cell setSubtitleText: @"请选择"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEBaseScene *view = [[MEBaseScene alloc] init];
    view.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
    return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath: indexPath animated: false];
    if (indexPath.row == 0 && indexPath.section == 0) {
        METextFieldCell *cell = [self.table cellForRowAtIndexPath: indexPath];
        [cell.input becomeFirstResponder];
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        [self userSelectGender];
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        [self userSelectBirthDay];
    }
    if (indexPath.row == 0 && indexPath.section == 1) {
        [self userSelectRelationWithBaby];
    }
    if (indexPath.row == 1 && indexPath.section == 1) {
        [self userSelectNursery];
    }
}

#pragma mark - lazyloading
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@[@"孩子姓名", @"性别", @"生日"], @[@"与宝宝关系", @"幼儿园"]];
    }
    return _titles;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
        _table.tableFooterView = [UIView new];
        _table.scrollEnabled = false;
        _table.separatorColor = UIColorFromRGB(0xF3F3F3);
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_table registerNib: [UINib nibWithNibName: @"MEPersonalDataCell" bundle: nil] forCellReuseIdentifier: selectCellIdef];
        [_table registerNib: [UINib nibWithNibName: @"METextFieldCell" bundle: nil] forCellReuseIdentifier: inputCellIdef];
    }
    return _table;
}

- (MEBaseButton *)confirmBtn {
    if (_confirmBtn) {
        _confirmBtn = [[MEBaseButton alloc] init];
        [_confirmBtn setTitle: @"添加" forState: UIControlStateNormal];
        _confirmBtn.titleLabel.font = UIFontPingFangSC(15);
        [_confirmBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
        [_confirmBtn addTarget: self action: @selector(sendAddChildMsgToServer) forControlEvents: UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
