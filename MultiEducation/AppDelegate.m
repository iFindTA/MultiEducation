//
//  AppDelegate.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MESignInProfile.h"
#import "MEBaseTabBarProfile.h"
#import "MEBaseNavigationProfile.h"
#import "MEBabyRootProfile.h"
#import "MEIndexRootProfile.h"
#import "MEPersonalRootProfile.h"
#import "MEChatSessionRootProfile.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <UINavigationController+SJVideoPlayerAdd.h>
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) MEBaseTabBarProfile *winRootTabProfile;

@property (nonatomic, strong, readwrite) MEBaseNavigationProfile *winProfile;

@property (nonatomic, strong, readwrite) MEPBUser *curUser;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

#if DEBUG
    NSString *sandboxPath = NSHomeDirectory();
    NSLog(@"sandbox path for debug:%@", sandboxPath);
#endif
    //create user
    //init root navigation profile
    //BOOL signedin = [MEUserVM whetherExistValidSignedInUser];
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    BOOL whetherDidSignout = [usrDefaults boolForKey:ME_USER_DID_INITIATIVE_LOGOUT];
    if (!whetherDidSignout) {
        self.curUser = [MEUserVM fetchLatestSignedInUser];
    }
    MEDisplayStyle style ;
    if (!self.curUser) {
        style = MEDisplayStyleAuthor;
    } else {
        style = (self.curUser.isTourist)?MEDisplayStyleVisitor:MEDisplayStyleMainSence;
    }
    UIViewController *rootProfile = [self assembleRootProfileWhileUserChangeState:style];
    self.winProfile = [[MEBaseNavigationProfile alloc] initWithRootViewController:rootProfile];
    [self.winProfile setNavigationBarHidden:true animated:true];
    self.winProfile.sj_gestureType = SJFullscreenPopGestureType_Full;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.winProfile;
    [self.window makeKeyAndVisible];
    //for input
    [IQKeyboardManager sharedManager].enable = true;
    //for umeng
    UMConfigInstance.appKey = ME_UMENG_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];
    //for chinese-policy
    [PBService configBaseURL:ME_APP_BASE_HOST];
    [[PBService shared] challengePermissionWithResponse:^(id _Nullable res, NSError * _Nullable err) {
        
    }];
    
    //notification-apns
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [application registerForRemoteNotifications];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --- apns

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * token = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:ME_APPLICATION_APNE_TOKEN];
    [defaults synchronize];
    NSLog(@"apns: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
}

#pragma mark -- handle root profile

- (NSArray *)map4TabBarProfiles {
    NSMutableArray *sets = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:0];
    CGFloat imgSize = ME_TABBAR_ITEM_IMAGE_SIZE / MESCREEN_SCALE;
    UIColor *color = pbColorMake(ME_THEME_COLOR_VALUE);
    //首页
    NSString *title = @"首页";
    NSString *code = @"\U0000e6d0";
    UIImage *icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
    [map setObject:icon forKey:title];
    [sets addObject:map.copy];[map removeAllObjects];
    //聊天
    title = @"聊天";code = @"\U0000e8e3";
    icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
    [map setObject:icon forKey:title];
    [sets addObject:map.copy];[map removeAllObjects];
    //宝宝
    title = @"宝宝成长";code = @"\U0000e6d0";
    icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
    [map setObject:icon forKey:title];
    [sets addObject:map.copy];[map removeAllObjects];
    //幼儿园
    title = @"幼儿园";code = @"\U0000e8e3";
    icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
    [map setObject:icon forKey:title];
    [sets addObject:map.copy];[map removeAllObjects];
    //个人
    title = @"个人";code = @"\U0000e7a3";
    icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
    [map setObject:icon forKey:title];
    [sets addObject:map.copy];[map removeAllObjects];
    
    return sets.copy;
}

- (UIViewController *)assembleRootProfileWhileUserChangeState:(MEDisplayStyle)style {
    
#if DEBUG
    
#endif
    
    UIViewController *destProfile = nil;
    if (style & MEDisplayStyleMainSence) {
        UIColor *color = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        //首页
        NSString *title = @"首页";
        UIImage *image = [UIImage imageNamed:@"bar_index"];
        UIImage *selectImg = [image pb_darkColor:color lightLevel:1.f];
        MEIndexRootProfile *index = [[MEIndexRootProfile alloc] init];
        MEBaseNavigationProfile *indexNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:index];
        indexNavi.navigationBarHidden = true;
        indexNavi.tabBarItem.title = title;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImg = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        indexNavi.tabBarItem.image = image;
        indexNavi.tabBarItem.selectedImage = selectImg;
        //聊天
        title = @"聊天";
        image = [UIImage imageNamed:@"bar_chat"];
        selectImg = [image pb_darkColor:color lightLevel:1.f];
        MEChatSessionRootProfile *chat = [[MEChatSessionRootProfile alloc] init];
        MEBaseNavigationProfile *chatNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:chat];
        chatNavi.navigationBarHidden = true;
        chatNavi.tabBarItem.title = title;
        chatNavi.tabBarItem.image = image;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImg = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        chatNavi.tabBarItem.image = image;
        chatNavi.tabBarItem.selectedImage = selectImg;
        //宝宝成长
        title = ((self.curUser.userType == MEPBUserRole_Teacher)?@"班级":@"宝宝成长");
        image = [UIImage imageNamed:@"bar_baby"];
        //selectImg = [UIImage imageNamed:@"bar_baby_select"];
        selectImg = [image pb_darkColor:color lightLevel:1.f];
        MEBabyRootProfile *baby = [[MEBabyRootProfile alloc] init];
        MEBaseNavigationProfile *babyNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:baby];
        babyNavi.navigationBarHidden = true;
        babyNavi.tabBarItem.title = title;
        babyNavi.tabBarItem.image = image;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImg = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        babyNavi.tabBarItem.image = image;
        babyNavi.tabBarItem.selectedImage = selectImg;
        //个人
        title = @"个人";
        image = [UIImage imageNamed:@"bar_personal"];
        selectImg = [image pb_darkColor:color lightLevel:1.f];
        MEPersonalRootProfile *personal = [[MEPersonalRootProfile alloc] init];
        MEBaseNavigationProfile *personalNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:personal];
        personalNavi.navigationBarHidden = true;
        personalNavi.tabBarItem.title = title;
        personalNavi.tabBarItem.image = image;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImg = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        personalNavi.tabBarItem.image = image;
        personalNavi.tabBarItem.selectedImage = selectImg;
        //root tabbar
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
        MEBaseTabBarProfile *profile = [[MEBaseTabBarProfile alloc] init];
        profile.viewControllers = @[indexNavi, chatNavi, babyNavi, personalNavi];
        
        destProfile = profile;
    } else if (style & MEDisplayStyleVisitor) {
        MEIndexRootProfile *profile = [[MEIndexRootProfile alloc] init];
        destProfile = profile;
    } else {
        //当前没有可用的user 需要用户重新登录授权
        MESignInProfile *profile = [[MESignInProfile alloc] init];
        destProfile = profile;
    }
    
    return destProfile;
}

#pragma mark -- handle splash for sence change

- (void)changeDisplayStyle:(uint)style {
    if (style & MEDisplayStyleMainSence) {
        UIViewController *profile = [self assembleRootProfileWhileUserChangeState:style];
        if ([profile isKindOfClass:[MEBaseTabBarProfile class]] ||
            [profile isMemberOfClass:[MEBaseTabBarProfile class]]) {
            self.winRootTabProfile = (MEBaseTabBarProfile *)profile;
        }
        [self.winProfile setViewControllers:@[self.winRootTabProfile] animated:true];
    } else {
        UIViewController *authorProfile = [self assembleRootProfileWhileUserChangeState:style];
        [self.winProfile setViewControllers:@[authorProfile] animated:true];
    }
}

#pragma mark --- User abouts

- (void)updateCurrentSignedInUser:(MEPBUser *)usr {
    self.curUser = usr;
}

@end
