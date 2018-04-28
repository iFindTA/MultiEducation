//
// Created by nanhu on 2018/4/3.
// Copyright (c) 2018 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import <objc/message.h>
#import "MEBaseProfile.h"
#import "MEBaseTabBarProfile.h"
#import "PBBaseTabBarProfile+Hidden.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MEBaseProfile ()

@end

@implementation MEBaseProfile

- (void)dealloc {
    NSLog(@"class--%@---released...", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
    self.view.backgroundColor = [UIColor whiteColor];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)splash2ChangeDisplayStyle:(MEDisplayStyle)style {
    [self.appDelegate changeDisplayStyle:style];
}

- (AppDelegate *)appDelegate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}

- (MEBaseTabBarProfile *)rootTabBar {
    AppDelegate *delegate = [self appDelegate];
    SEL aSel = NSSelectorFromString(@"winRootTabProfile");
    if (delegate && [delegate respondsToSelector:aSel]) {
        //FLKBaseTabBarController *tabBarCtr = [delegate rootTabBar];
        MEBaseTabBarProfile* (*msgSend)(id, SEL) = (MEBaseTabBarProfile* (*)(id, SEL))objc_msgSend;
        MEBaseTabBarProfile *tabBarCtr = msgSend(delegate, aSel);
        return tabBarCtr;
    }
    return nil;
}

#pragma mark -- tabBar event

- (void)hideNavigationBar {
    self.navigationBar.hidden = true;
}

- (void)hideTabBar:(BOOL)hidden animated:(BOOL)animated {
    MEBaseTabBarProfile *tabBarCtr = [self rootTabBar];
    [tabBarCtr setTabBarHidden:hidden animated:animated delaysContentResizing:true completion:nil];
}

- (void)setBadgeValue:(NSInteger)value atIndex:(NSUInteger)idx {
    MEBaseTabBarProfile *tabBarCtr = [self rootTabBar];
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

- (UIBarButtonItem *)backBarButtonItemWithIconUnicode:(NSString *)code color:(UIColor *)color {
    CGFloat itemSize = 28;
    CGFloat fontSize = PBFontTitleSize;
    NSString *fontName = @"iconfont";
    UIFont *font = [UIFont fontWithName:fontName size:fontSize * 2];
    //    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, itemSize, itemSize);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:code forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(defaultGoBackStack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [barItem setTintColor:color];
    return barItem;
}

- (void)backStackBeforeClass:(Class)aClass {
    if (aClass == nil) {
        return;
    }
    NSArray *tmps = self.navigationController.viewControllers;
    __block NSMutableArray <UIViewController*>*__tmp = [NSMutableArray arrayWithCapacity:0];
    [tmps enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:aClass] ||
            [obj isMemberOfClass:aClass] ||
            obj.class == aClass) {
            *stop = true;
        } else {
            [__tmp addObject:obj];
        }
    }];
    [self.navigationController setViewControllers:__tmp.copy animated:true];
}

#pragma mark --- user relatives

- (UIViewController *)fetchTopProfile4Window:(UIWindow *)window {
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

- (UIViewController *)topestProfile {
    NSArray <UIWindow *>*windows = [UIApplication sharedApplication].windows;
    UIViewController *profile;UIWindow *win;
    NSEnumerator *enumerator = [windows reverseObjectEnumerator];
    while (win = [enumerator nextObject]) {
        UIViewController *tmpProfile = [self fetchTopProfile4Window:win];
        if (tmpProfile != nil) {
            profile = tmpProfile;
            NSLog(@"找到了topest:%@", win);
            break;
        }
    }
    return profile;
}

- (MEPBUser * _Nullable)currentUser; {
    return [self appDelegate].curUser;
}

- (void)handleTransitionError:(NSError *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
}

- (void)showSuccessHUD:(NSString *)hudString {
    if (hudString.length) {
        [SVProgressHUD showSuccessWithStatus:hudString];
    }
}

@end
