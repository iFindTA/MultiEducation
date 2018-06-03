//
//  MEForwardGEProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEDropDownMenu.h"
#import "MEForwardGEProfile.h"
#import "MEForwardEvaListVM.h"
#import "MEStudentsPanel.h"
#import "MEEvaluatePanel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MEForwardGEProfile ()

@property (nonatomic, strong) MEBaseScene *marginBaseLine;
@property (nonatomic, strong) MEDropDownMenu *dropDownMenu;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) ForwardEvaluateList *evaList;

@property (nonatomic, strong) MEStudentsPanel *studentPanel;
@property (nonatomic, strong) MEEvaluatePanel *evaluatePanel;

@property (nonatomic, assign) BOOL whetherParent;

@property (nonatomic, assign) int32_t semester_id, month_id;

@end

@implementation MEForwardGEProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _parameters = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (PBNavigationBar *)initializedNavigationBar {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat barHeight = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR;
    _marginBaseLine = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_marginBaseLine];
    [_marginBaseLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(barHeight);
    }];
    MEDropDownMenu *menu = [MEDropDownMenu dropDownWithSuperView:self.view];
    [self.view addSubview:menu];
    self.dropDownMenu = menu;
    [menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(barHeight);
    }];
    //callback
    weakify(self)
    menu.callback = ^(BOOL back, int32_t semester, int32_t month) {
        strongify(self)
        if (back) {
            [self defaultGoBackStack];
        } else {
            [self userDidExchangeSemester:semester month:month];
        }
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //*
    [IQKeyboardManager sharedManager].enable = false;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
    //*/
    [self fetchForwardEvaluateConditions];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //*
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].enableAutoToolbar = true;
    //*/
}

/**
 获取往期评价条件
 */
- (void)fetchForwardEvaluateConditions {
    int64_t gradeId = [self.parameters pb_longLongForKey:@"gradeId"];
    int32_t semester = [self.parameters pb_intForKey:@"semester"];
    ForwardEvaluate *fe = [[ForwardEvaluate alloc] init];
    fe.gradeId = gradeId;
    fe.semester = semester;
    weakify(self)
    MEForwardEvaListVM *vm = [[MEForwardEvaListVM alloc] init];
    [vm postData:[fe data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err; strongify(self)
        ForwardEvaluateList *list = [ForwardEvaluateList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            return ;
        }
        self.evaList = list;
        [self rebuildForwardEvaluateSubviews];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

- (void)rebuildForwardEvaluateSubviews {
    [self.dropDownMenu configureMenu:self.evaList];
}

/**
 切换学期/月份
 */
- (void)userDidExchangeSemester:(int32_t)semester month:(int32_t)month {
    _semester_id = semester; _month_id = month;
    //配置头部
    self.whetherParent = self.currentUser.userType == MEPBUserRole_Parent;
    if (!self.whetherParent) {
        //先清空数据
        [self.studentPanel removeFromSuperview];
        _studentPanel = nil;
        //再次渲染
        int64_t gradeId = [self.parameters pb_longLongForKey:@"gradeId"];
        int64_t classID = [self.parameters pb_longLongForKey:@"classId"];
        MEStudentsPanel *panel = [MEStudentsPanel panelWithSuperView:self.view topMargin:self.marginBaseLine];
        panel.type = 4;
        panel.month = month;
        panel.classID = classID;
        panel.gradeID = gradeId;
        panel.semester = semester;
        [self.view insertSubview:panel belowSubview:self.marginBaseLine];
        [panel loadAndConfigure];
        self.studentPanel = panel;
        weakify(self)
        //touch switch student callback
        panel.callback = ^(int64_t sid, int64_t pre_sid) {
            strongify(self);
            [self userDidExchange2Student:sid preStudent:pre_sid];
        };
        //编辑完成
        panel.editCallback = ^(BOOL done) {
            if (done) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜你！已经全部填写完毕了"];
            }
        };
    }
    //配置 评价部分 先清空
    [self.evaluatePanel removeFromSuperview];
    _evaluatePanel = nil;
    //再次配置
    MEEvaluatePanel *panel = [[MEEvaluatePanel alloc] initWithFrame:CGRectZero father:self.view];
    [self.view insertSubview:panel belowSubview:self.marginBaseLine];
    self.evaluatePanel = panel;
    [panel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marginBaseLine.mas_bottom).offset(self.whetherParent?0:ME_STUDENT_PANEL_HEIGHT);
        make.left.bottom.right.equalTo(self.view);
    }];
    //callback
    weakify(self)
    panel.callback = ^(int64_t sid, MEEvaluateState state) {
        NSString *alertInfo = self.whetherParent ? @"评价成功！" : @"评价成功，填写下一个吧！";
        [SVProgressHUD showSuccessWithStatus:alertInfo];
        strongify(self)
        [self.studentPanel updateStudent:sid status:state];
    };
    //whether parent
    if (self.whetherParent) {
        int64_t sid = [self.parameters pb_longLongForKey:@"studentId"];
        [self userDidExchange2Student:sid preStudent:0];
    }
}

#pragma mark --- 切换学生
- (void)userDidExchange2Student:(int64_t)sid preStudent:(int64_t)preSid {
    /**
     step1 查询之前学生是否需要暂存 需要则先暂存 否则不做处理
     step2 拉取当前学生的评价
     */
    int64_t gradeId = [self.parameters pb_longLongForKey:@"gradeId"];
    GrowthEvaluate *e = [[GrowthEvaluate alloc] init];
    e.studentId = sid;
    e.gradeId = gradeId;
    e.month = _month_id;
    e.semester = _semester_id;
    [self.evaluatePanel exchangedStudent2Evaluate:e];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
