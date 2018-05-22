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

@interface MEForwardGEProfile ()

@property (nonatomic, strong) PBNavigationBar *navigatorBar;
@property (nonatomic, strong) MEDropDownMenu *dropDownMenu;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) ForwardEvaluateList *evaList;

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
    /*
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
    [self.view addSubview:naviBar];
    self.navigatorBar = naviBar;
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [MEKits defaultGoBackBarButtonItemWithTarget:self color:pbColorMake(ME_THEME_COLOR_TEXT)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"往期评价"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigatorBar pushNavigationItem:item animated:true];
    //*/
    CGFloat barHeight = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR;
    MEDropDownMenu *menu = [MEDropDownMenu dropDownWithSuperView:self.view];
    [self.view addSubview:menu];
    self.dropDownMenu = menu;
    [menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(barHeight);
    }];
    //callback
    weakify(self)
    menu.callback = ^(BOOL back) {
        strongify(self)
        [self defaultGoBackStack];
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
    [self fetchForwardEvaluateConditions];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
