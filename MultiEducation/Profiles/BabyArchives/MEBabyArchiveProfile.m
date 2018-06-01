//
//  MEBabyArchiveProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyArchiveProfile.h"
#import "MEStudentsPanel.h"
#import "MEBabyInfoContent.h"
#import "MEParentInfoContent.h"
#import "MEBabyIndexVM.h"
#import "MebabyIndex.pbobjc.h"

@interface MEBabyArchiveProfile ()

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) MEStudentsPanel *panel;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) MEBabyInfoContent *babyContent;
@property (nonatomic, strong) MEParentInfoContent *parentContent;

@end

@implementation MEBabyArchiveProfile

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [MEKits defaultGoBackBarButtonItemWithTarget:self color:pbColorMake(ME_THEME_COLOR_TEXT)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"宝宝档案"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    [self.view addSubview: self.scroll];
    [self.scroll addSubview: self.babyContent];
    [self.scroll addSubview: self.parentContent];
    
    //layout
//    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.
//    }];
    
    
    [self configureStudentPanel];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyloading
- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame: CGRectZero];
        _scroll.backgroundColor = [UIColor whiteColor];
    }
    return _scroll;
}

- (MEBabyInfoContent *)babyContent {
    if (!_babyContent) {
        _babyContent = [[MEBabyInfoContent alloc] initWithFrame: CGRectZero];
    }
    return _babyContent;
}

- (MEParentInfoContent *)parentContent {
    if (!_parentContent) {
        _parentContent = [[MEParentInfoContent alloc] initWithFrame: CGRectZero];
    }
    return _parentContent;
}

- (void)configureStudentPanel {
    GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
    
    _panel = [MEStudentsPanel panelWithSuperView: self.view topMargin: self.navigationBar];
    _panel.autoScrollNext = false;
    _panel.classID = index.studentArchives.classId;
    _panel.gradeID = index.gradeId;
    _panel.semester = index.semester;

    [self.view insertSubview:_panel belowSubview: self.navigationBar];
    [self.view insertSubview:_panel aboveSubview: self.scroll];
    
    [_panel loadAndConfigure];
    
    //touch switch student callback
    weakify(self);
    _panel.callback = ^(int64_t sid, int64_t pre_sid) {
        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
        strongify(self);


    };
    
}


@end
