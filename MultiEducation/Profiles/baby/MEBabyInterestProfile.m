//
//  MEBabyInterest.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInterestProfile.h"
#import "MEBabyInterestingContent.h"
#import "Meuser.pbobjc.h"
#import "MEStudentsPanel.h"
#import "MEBabyIndexVM.h"
#import "Meclass.pbobjc.h"

#define CONTENT_HEIGHT MESCREEN_HEIGHT - ME_STUDENT_PANEL_HEIGHT - ME_HEIGHT_NAVIGATIONBAR - [MEKits statusBarHeight]

@interface MEBabyInterestProfile () {
    MEPBClass *_classPb;   //role == teacher || gardener
    int64_t _stuId;     //selected student's id ,if role == parent, from pre stack controller
}

@property (nonatomic, strong) MEBabyInterestingContent *content;
@property (nonatomic, strong) MEStudentsPanel *panel;
@end

@implementation MEBabyInterestProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _classPb = [params objectForKey: @"classPb"];
        _stuId = [[params objectForKey: @"stuId"] longLongValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    
    [self.view addSubview: self.content];
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        self.content.center = CGPointMake(MESCREEN_WIDTH / 2, MESCREEN_HEIGHT / 2);
    } else {
        [self configureStudentPanel];
        CGFloat y = ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight] + ME_STUDENT_PANEL_HEIGHT;
        self.content.frame = CGRectMake(0, y, MESCREEN_WIDTH, CONTENT_HEIGHT);
    }
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"趣事趣影"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    item.rightBarButtonItem = [MEKits barWithImage: [UIImage imageNamed: @"appicon_placeholder"] target: self eventSelector: @selector(pushToSendBabyInterestingProfileItemTouchEvent)];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)pushToSendBabyInterestingProfileItemTouchEvent {
    //FIXME: 每月只能发送一次，加一下判断，如果当月已经发送，点击提示toast
    NSString *urlStr = @"profile://root@MESendIntersetingProfile";
    NSDictionary *params = @{@"classPb": _classPb, @"stuId": @(_stuId)};
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 配置头部
- (void)configureStudentPanel {
    GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
    
    _panel = [MEStudentsPanel panelWithSuperView: self.view topMargin: self.navigationBar];
    _panel.classID = _classPb.id_p;
    _panel.gradeID = _classPb.gradeId;
    _panel.semester = _classPb.semester;
    _panel.month = index.month;
    _panel.type = 6;
    [self.view insertSubview:_panel belowSubview: self.navigationBar];
    [self.view insertSubview:_panel aboveSubview: self.content];

    [_panel loadAndConfigure];
    
    //touch switch student callback
    weakify(self);
    _panel.callback = ^(int64_t sid, int64_t pre_sid) {
        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
        strongify(self);
        _stuId = sid;
    };
    //编辑完成
    _panel.editCallback = ^(BOOL done) {
        
    };
}

#pragma mark - lazyloading
- (MEBabyInterestingContent *)content {
    if (!_content) {
        _content = [[MEBabyInterestingContent alloc] initWithFrame: CGRectMake(0, ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight], MESCREEN_WIDTH, CONTENT_HEIGHT)];
        _content.items = @[@0, @1, @2];
        _content.pagingEnabled = true;
        _content.DidSelectCardHandler = ^(NSInteger index) {
            
        };
    }
    return _content;
}


@end
