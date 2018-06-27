//
//  MEInputChildInfoContent_ Intelligence.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEInputChildInfoContent.h"
#import "METextFieldCell.h"
#import "MESingleSelectCell.h"
#import "MEActionCell.h"
#import "AppDelegate.h"
#import "MeschoolAddress.pbobjc.h"
#import "Meclass.pbobjc.h"
#import "MEAddChildVM.h"
#import "MEUserVM.h"
#import <ActionSheetPicker.h>

static CGFloat const tableHeight = 270;
static CGFloat const cellHeight = 54;

static NSString * const inputCellIdef = @"input_cell_idef";
static NSString * const genderCellIdef = @"gender_cell_idef";
static NSString * const selectCellIdef = @"select_cell_idef";

@interface MEInputChildInfoContent() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MEBaseButton *skipBtn;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) StudentPb *addStu;
@property (nonatomic, strong) MEPBClass *addClass;

@end

@implementation MEInputChildInfoContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubviews];
    }
    return self;
}

- (void)customSubviews {
    //bg
    MEBaseScene *signBgScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    signBgScene.layer.cornerRadius = ME_LAYOUT_MARGIN*2.5;
    signBgScene.layer.masksToBounds = true;
    [self addSubview:signBgScene];
    [signBgScene makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //title
    NSString *info = @"添加孩子";
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE+ME_LAYOUT_OFFSET);
    UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    MEBaseLabel *title = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    title.font = font;
    title.textColor = fontColor;
    title.text = info;
    [signBgScene addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY+ME_LAYOUT_OFFSET);
        make.left.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(28);
    }];
    //code sign-in
    font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    MEBaseButton *codeBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    codeBtn.titleLabel.font = font;
    [codeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [codeBtn setTitleColor:fontColor forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(userDidSkipAddChild) forControlEvents:UIControlEventTouchUpInside];
    [signBgScene addSubview:codeBtn];self.skipBtn = codeBtn;
    [codeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title.mas_centerY);
        make.right.equalTo(signBgScene).offset(-ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(ME_LAYOUT_BOUNDARY);
    }];
    
    _table = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor whiteColor];
    _table.tableFooterView = [UIView new];
    _table.scrollEnabled = false;
    _table.separatorColor = UIColorFromRGB(0xF3F3F3);
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table registerNib: [UINib nibWithNibName: @"MEActionCell" bundle: nil] forCellReuseIdentifier: selectCellIdef];
    [_table registerNib: [UINib nibWithNibName: @"METextFieldCell" bundle: nil] forCellReuseIdentifier: inputCellIdef];
    [_table registerNib: [UINib nibWithNibName: @"MESingleSelectCell" bundle: nil] forCellReuseIdentifier: genderCellIdef];
    [self addSubview: self.table];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title);
        make.right.mas_equalTo(codeBtn);
        make.top.mas_equalTo(title.mas_bottom).mas_offset(ME_LAYOUT_MARGIN*2.5);
        make.height.mas_equalTo(tableHeight);
    }];
    
    // sign in
    font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = ME_HEIGHT_NAVIGATIONBAR * 0.5;
    btn.layer.masksToBounds = true;
    btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(userDidTouchAddChild) forControlEvents:UIControlEventTouchUpInside];
    [signBgScene addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.table.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(signBgScene).offset(ME_LAYOUT_BOUNDARY*1.5);
        make.right.equalTo(signBgScene).offset(-ME_LAYOUT_BOUNDARY*1.5);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];

    //bottom margin
    [signBgScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
    }];
    
}

- (void)userDidTouchAddChild {
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
        if (self.didAddChildSuccessCallback) {
            self.addStu = self.inputStu;
            [MEUserVM updateUserStuent: self.addStu cls: self.addClass uid: self.currentUser.uid];
            self.didAddChildSuccessCallback();
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)userDidSkipAddChild {
    if (self.didSkipAddChildCallback) {
        self.didSkipAddChildCallback();
    }
}

- (void)userSelectBirthDay {
    MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:2 inSection:0]];
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
    MEActionCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 3 inSection: 0]];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        METextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier: inputCellIdef forIndexPath: indexPath];
        cell.titleLab.text = self.titles[indexPath.row];
        return cell;
    } else if (indexPath.row == 1) {
        MESingleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier: genderCellIdef forIndexPath: indexPath];
        cell.didChangeSelectCallback = ^(int32_t index) {
            self.inputStu.gender = index;
        };
        cell.titleLab.text = self.titles[indexPath.row];
        return cell;
    } else {
        MEActionCell *cell = [tableView dequeueReusableCellWithIdentifier: selectCellIdef forIndexPath: indexPath];
        cell.titleLab.text = self.titles[indexPath.row];
        [cell setSubtitleText: @"请选择"];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: false];
    if (indexPath.row == 0) {
        METextFieldCell *cell = [self.table cellForRowAtIndexPath: indexPath];
        [cell.input becomeFirstResponder];
    }
    if (indexPath.row == 1) {
        
    }
    if (indexPath.row == 2) {
        [self userSelectBirthDay];
    }
    if (indexPath.row == 3) {
        [self userSelectRelationWithBaby];
    }
    if (indexPath.row == 4) {
        [self userSelectNursery];
    }
}


#pragma mark - lazyloading
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"孩子姓名", @"性别", @"生日", @"与宝宝关系", @"幼儿园"];
    }
    return _titles;
}

- (StudentPb *)inputStu {
    if (!_inputStu) {
        _inputStu = [[StudentPb alloc] init];
        _inputStu.gender = 1;
    }
    return _inputStu;
}

@end
