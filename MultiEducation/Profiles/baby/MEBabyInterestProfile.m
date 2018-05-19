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

#define CONTENT_HEIGHT adoptValue(488.f)

@interface MEBabyInterestProfile () {
    int64_t _classId;   //role == teacher || gardener
    int64_t _stuId;     //role == parent
}

@property (nonatomic, strong) MEBabyInterestingContent *content;
@property (nonatomic, strong) MEStudentsPanel *panel;
@end

@implementation MEBabyInterestProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _classId = [[params objectForKey: @"classId"] longLongValue];
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
    } else if (self.currentUser.userType == MEPBUserRole_Teacher) {
        if (self.currentUser.teacherPb.classPbArray.count > 0) {
            if (self.currentUser.teacherPb.classPbArray.count == 1) {
                
            } else {
                
            }
        }
    } else if (self.currentUser.userType == MEPBUserRole_Gardener) {
        
    } else {
        
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
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
    [MEKits handleError: error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 配置头部
- (void)configureStudentPanelWithClassID:(int64_t)cid {
    _panel = [MEStudentsPanel panelWithClassID:cid superView:self.view topMargin:self.navigationBar];
    [self.view insertSubview:_panel belowSubview:self.navigationBar];
    [_panel loadAndConfigure];
    
    //touch switch student callback
    _panel.callback = ^(int64_t sid, int64_t pre_sid) {
        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
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
