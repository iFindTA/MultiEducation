//
//  MEChatProfile.m
//  MultiEducation
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "MEChatProfile.h"
#import <PBBaseClasses/PBNavigationBar.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MEChatProfile () 

@property (nonatomic, strong) PBNavigationBar *navigationBar;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;

@end

@implementation MEChatProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = false;
        
        _params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"super class:%@", NSStringFromClass(self.conversationMessageCollectionView.superview.class));
    [self.view addSubview:self.navigationBar];
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *back = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.title];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //adjust conversation frame
    [self.conversationMessageCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatSessionInputBarControl.mas_top);
    }];
    [RCIM sharedRCIM].globalNavigationBarTintColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    /* setup location proxy
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType targetId:self.targetId success:^(id<RCRealTimeLocationProxy> locationShare) {
        
    } error:^(RCRealTimeLocationErrorCode status) {
        NSLog(@"failed to fetch real-time location with Code:%ld", (long)status);
    }];//*/
    // setup extend plugins
    [self adgustmentExpandPlugins];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = false;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].enableAutoToolbar = true;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =  [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultGoBackStack {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark --- lazy loader

- (PBNavigationBar *)navigationBar {
    if (!_navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(0xFFFFFF);
        UIColor *barTintColor = pbColorMake(ME_THEME_COLOR_VALUE);//影响背景
        UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(0xE8E8E8)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        //adjust frame
        CGFloat height = [naviBar barHeight];
        barBounds = CGRectMake(0, 0, MESCREEN_WIDTH, height);
        [naviBar setFrame:barBounds];
        _navigationBar = naviBar;
    }
    
    return _navigationBar;
}

#pragma mark --- 扩展功能栏 ---

/**
 调整扩展功能区
 */
- (void)adgustmentExpandPlugins {
    NSArray *items = [self.chatSessionInputBarControl.pluginBoardView allItems];
    //去除红包功能
    NSUInteger removeIndex = 3;
    if (removeIndex < items.count) {
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:removeIndex];
    }
    //去除发送GIF
    NSArray<UIView*>*subs = self.chatSessionInputBarControl.emojiBoardView.subviews;
    UIView *extentKit;
    for (UIView *s in subs) {
        if (fabs(s.bounds.size.height - ME_LAYOUT_SUBBAR_HEIGHT) <= ME_LAYOUT_OFFSET) {
            extentKit = s;
            break;
        }
    }
    subs = extentKit.subviews;
    UIScrollView *extentScroll;
    for (UIView *s in subs) {
        if ([s isKindOfClass:[UIScrollView class]]||[s isMemberOfClass:[UIScrollView class]]) {
            extentScroll = (UIScrollView*)s;
            break;
        }
    }
    subs = extentScroll.subviews;
    /*只删除GIF一项 其余前移
    int i = 0;
    for (UIView *s in subs) {
        if (fabs(s.frame.origin.x - ME_LAYOUT_SUBBAR_HEIGHT) <= ME_LAYOUT_OFFSET) {
            [s removeFromSuperview];
        } else if (i > 0) {
            CGRect frame = s.frame;
            frame.origin.x = s.frame.origin.x-frame.size.width;
            [s setFrame:frame];
        }
        
        i++;
    }//*/
    //全部删除除了第一个
    for (UIView *s in subs) {
        if (s.frame.origin.x >= ME_LAYOUT_SUBBAR_HEIGHT) {
            [s removeFromSuperview];
        }
    }
    
    /*加入短视频扩展
    NSString *iconTitle = @"短视频";
    NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
    UIColor *iconColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *icon = [UIImage pb_iconFont:nil withName:@"\U0000e6a0" withSize:iconSize withColor:iconColor];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:icon title:iconTitle atIndex:removeIndex tag:removeIndex];
    //*/
}

@end
