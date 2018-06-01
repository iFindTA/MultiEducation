//
//  MEForwardSEProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/29.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEDropDownMenu.h"
#import "MEStudentsPanel.h"
#import "MESemesterEvaPanel.h"
#import "MEForwardSEProfile.h"

@interface MEForwardSEProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) MEBaseScene *marginBaseLine;
@property (nonatomic, strong) MEDropDownMenu *dropDownMenu;

@property (nonatomic, strong) MEStudentsPanel *studentPanel;
@property (nonatomic, strong) MESemesterEvaPanel *evaluatePanel;

@property (nonatomic, strong) SemesterEvaluateList *evaList;
@property (nonatomic, assign) BOOL whetherParent;

@property (nonatomic, assign) int32_t semester_id, month_id;

@end

@implementation MEForwardSEProfile

- (id)__initWithParams:(NSDictionary *)parsme {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:parsme];
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
//            [self userDidExchangeSemester:semester month:month];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self fetchForwardSEEvaluateConditions];
}

/**
 获取往期评价条件
 */
- (void)fetchForwardSEEvaluateConditions {
    int64_t gradeId = [self.params pb_longLongForKey:@"gradeId"];
    int32_t semester = [self.params pb_intForKey:@"semester"];
    SemesterEvaluate *fe = [[SemesterEvaluate alloc] init];
    fe.gradeId = gradeId;
    fe.semester = semester;
    weakify(self)
    MEForwardEvaListVM *vm = [[MEForwardEvaListVM alloc] init];
    [vm postData:[fe data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err; strongify(self)
        SemesterEvaluateList *list = [SemesterEvaluateList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            return ;
        }
        self.evaList = list;
        [self rebuildSEForwardEvaluateSubviews];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

- (void)rebuildSEForwardEvaluateSubviews {
    
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
