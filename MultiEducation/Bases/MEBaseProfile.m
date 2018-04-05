//
// Created by nanhu on 2018/4/3.
// Copyright (c) 2018 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"
#import "AppDelegate.h"

@implementation MEBaseProfile

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (PBNavigationBar *)initializedNavigationBar {

    if (!self.navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(0xFFFFFF);
        UIColor *barTintColor = pbColorMake(ME_THEME_COLOR_VALUE);//影响背景
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

- (void)splash2ChangeDisplayStyle:(MEDisplayStyle)style {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app changeDisplayStyle:style];
}

@end
