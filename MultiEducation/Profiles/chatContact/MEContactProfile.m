//
//  MEContactProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import <YCXMenu/YCXMenu.h>
#import "MEContactProfile.h"
#import "MEBaseNavigationProfile.h"

@interface MEContactProfile ()

@property (nonatomic, strong) NSArray <YCXMenuItem*> *menuItems;

@end

@implementation MEContactProfile

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
    
    UIImage *moreImage = [UIImage imageNamed:@"chat_contact_add"];
    UIColor *backColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *backItem = [MEKits backBarWithColor:backColor target:self withSelector:@selector(defaultGoBackStack)];
    UIBarButtonItem *moreItem = [MEKits barWithImage:moreImage target:self eventSelector:@selector(userDidTouchQRCodeScanEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"通讯录"];
    item.leftBarButtonItems = @[spacer, backItem];
    item.rightBarButtonItems = @[spacer, moreItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy loading

- (NSArray<YCXMenuItem*>*)menuItems {
    if (!_menuItems) {
        NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
        UIColor *iconColor = [UIColor whiteColor];
        NSString *title = @"发起群聊";
        UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e618" withSize:iconSize withColor:iconColor];
        YCXMenuItem *chatItem = [YCXMenuItem menuItem:title image:img tag:0 userInfo:nil];
        img = [UIImage pb_iconFont:nil withName:@"\U0000e62d" withSize:iconSize withColor:iconColor];
        title = @"扫一扫";
        YCXMenuItem *scanItem = [YCXMenuItem menuItem:title image:img target:self action:@selector(userDidTouchQRCodeScanEvent)];
        _menuItems = [NSArray arrayWithObjects:chatItem, scanItem, nil];
    }
    return _menuItems;
}

#pragma mark --- User Interface Touch Events

- (void)navigationBarMoreTouchEvent {
    NSUInteger iconSize = ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE;
    CGRect bounds = CGRectMake(MESCREEN_WIDTH-iconSize-ME_LAYOUT_MARGIN*2, ME_HEIGHT_NAVIGATIONBAR+ME_LAYOUT_MARGIN, iconSize, iconSize);
    [YCXMenu showMenuInView:self.view fromRect:bounds menuItems:self.menuItems selected:^(NSInteger index, YCXMenuItem *item) {
        
    }];
}

- (void)userDidTouchQRCodeScanEvent {
    
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
