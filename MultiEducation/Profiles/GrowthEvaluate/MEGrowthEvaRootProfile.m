//
//  MEGrowthEvaRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEGrowthEvaRootProfile.h"
#import "MEStudentsPanel.h"
#import "MEEvaluatePanel.h"

@interface MEGrowthEvaRootProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) MEStudentsPanel *studentPanel;
@property (nonatomic, strong) MEEvaluatePanel *evaluatePanel;

@property (nonatomic, assign) BOOL whetherParent;

@end

@implementation MEGrowthEvaRootProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (PBNavigationBar *)initializedNavigationBar {
    if (!self.navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(ME_THEME_COLOR_TEXT);
        UIColor *barTintColor = pbColorMake(0xFFFFFF);//影响背景
        UIFont *font = [UIFont boldSystemFontOfSize:PBFontTitleSize + PBFONT_OFFSET];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(PB_NAVIBAR_SHADOW_HEX)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        
        return naviBar;
    }
    
    return self.navigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [MEKits defaultGoBackBarButtonItemWithTarget:self color:pbColorMake(ME_THEME_COLOR_TEXT)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"发展评价"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    //配置头部
    self.whetherParent = self.currentUser.userType == MEPBUserRole_Parent;
    if (!self.whetherParent) {
        int64_t classID = [self.params[@"classId"] longLongValue];
        [self configureStudentPanelWithClassID:classID];
    }
    
    //配置评价部分
    [self configureEvaluatePanel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 配置头部
- (void)configureStudentPanelWithClassID:(int64_t)cid {
    MEStudentsPanel *panel = [MEStudentsPanel panelWithClassID:cid superView:self.view topMargin:self.navigationBar];
    [self.view insertSubview:panel belowSubview:self.navigationBar];
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
        
    };
}

#pragma mark --- 配置切换
- (void)configureEvaluatePanel {
    MEEvaluatePanel *panel = [[MEEvaluatePanel alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:panel belowSubview:self.studentPanel];
    self.evaluatePanel = panel;
    [panel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(self.whetherParent?0:ME_STUDENT_PANEL_HEIGHT);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark --- 切换学生
- (void)userDidExchange2Student:(int64_t)sid preStudent:(int64_t)preSid {
    NSLog(@"切换学生:%lld", sid);
    /**
     step1 查询之前学生是否需要暂存 需要则先暂存 否则不做处理
     step2 拉取当前学生的评价
     */
    int64_t gradeId = [self.params pb_longLongForKey:@"gradeId"];
    int64_t semester = [self.params pb_longLongForKey:@"semester"];
    int32_t month = [self.params pb_intForKey:@"month"];
    GrowthEvaluate *e = [[GrowthEvaluate alloc] init];
    e.studentId = sid;
    e.gradeId = gradeId;
    e.month = month;
    e.semester = semester;
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
