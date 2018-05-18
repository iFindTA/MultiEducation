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

#define CONTENT_HEIGHT adoptValue(488.f)

@interface MEBabyInterestProfile ()

@property (nonatomic, strong) MEBabyInterestingContent *content;

@end

@implementation MEBabyInterestProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];

    
    [self.view addSubview: self.content];
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        self.content.center = CGPointMake(MESCREEN_WIDTH / 2, MESCREEN_HEIGHT / 2);
    } else if (self.currentUser.userType == MEPBUserRole_Teacher) {
        
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
