//
// Created by nanhu on 2018/4/3.
// Copyright (c) 2018 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"
#import "AppDelegate.h"
#import <objc/message.h>
#import "PBBaseTabBarProfile+Hidden.h"

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
    [self.appDelegate changeDisplayStyle:style];
}

- (AppDelegate *)appDelegate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}

- (PBBaseTabBarProfile *)rootTabBar {
    AppDelegate *delegate = [self appDelegate];
    SEL aSel = NSSelectorFromString(@"winRootTabProfile");
    if (delegate && [delegate respondsToSelector:aSel]) {
        //FLKBaseTabBarController *tabBarCtr = [delegate rootTabBar];
        PBBaseTabBarProfile* (*msgSend)(id, SEL) = (PBBaseTabBarProfile* (*)(id, SEL))objc_msgSend;
        PBBaseTabBarProfile *tabBarCtr = msgSend(delegate, aSel);
        return tabBarCtr;
    }
    return nil;
}

#pragma mark -- tabBar event

- (void)hideTabBar:(BOOL)hidden animated:(BOOL)animated {
    PBBaseTabBarProfile *tabBarCtr = [self rootTabBar];
    [tabBarCtr setTabBarHidden:hidden animated:animated delaysContentResizing:true completion:nil];
}

- (void)setBadgeValue:(NSInteger)value atIndex:(NSUInteger)idx {
    PBBaseTabBarProfile *tabBarCtr = [self rootTabBar];
    if (value < 0) {
        [tabBarCtr clearBadgeAtIndex:idx];
        return;
    }
    WBadgeStyle style = WBadgeStyleNew;
    if (value == 0) {
        style = WBadgeStyleRedDot;
    }else if (value > 0 && value < 1000){
        style = WBadgeStyleNumber;
    }
    [tabBarCtr updateBadgeStyle:style value:value atIndex:idx];
}

- (void)clearBadgeAtIndex:(NSUInteger)idx {
    PBBaseTabBarProfile *tabBarCtr = [self rootTabBar];
    [tabBarCtr clearBadgeAtIndex:idx];
}

@end
