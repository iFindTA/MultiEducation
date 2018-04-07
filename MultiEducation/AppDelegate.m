//
//  AppDelegate.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "MEDispatcher.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MEBaseTabBarProfile.h"
#import "MEBaseNavigationProfile.h"
#import <UINavigationController+SJVideoPlayerAdd.h>
#import "MEBabyProfile.h"
#import "MEIndexProfile.h"
#import "MEGardenProfile.h"
#import "MEPersonalProfile.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) MEBaseTabBarProfile *winRootTabProfile;

@property (nonatomic, strong, readwrite) MEBaseNavigationProfile *winProfile;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

#if DEBUG
    NSString *sandboxPath = NSHomeDirectory();
    NSLog(@"sandbox path for debug:%@", sandboxPath);
#endif
    
    //init root navigation profile
    BOOL signedin = [MEUserVM whetherExistValidSignedInUser];
    UIViewController *rootProfile = [self assembleRootProfileWhileUserValid:signedin];
    self.winProfile = [[MEBaseNavigationProfile alloc] initWithRootViewController:rootProfile];
    [self.winProfile setNavigationBarHidden:true animated:true];
    self.winProfile.sj_gestureType = SJFullscreenPopGestureType_Full;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.winProfile;
    [self.window makeKeyAndVisible];

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

#pragma mark -- handle root profile

- (NSArray *)map4TabBarProfiles {
    NSMutableArray *sets = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:0];
    CGFloat imgSize = ME_TABBAR_ITEM_IMAGE_SIZE / SCREEN_SCALE;
    UIColor *color = pbColorMake(ME_THEME_COLOR_VALUE);
    //宝宝
    NSString *title = @"宝宝";
    NSString *code = @"\U0000e6d0";
    UIImage *icon = [UIImage pb_iconFont:nil withName:code withSize:imgSize withColor:color];
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

- (UIViewController *)assembleRootProfileWhileUserValid:(BOOL)valid {
    
#if DEBUG
    NSArray *tabInfos = [self map4TabBarProfiles];
    NSDictionary *map = tabInfos[0];
    NSString *key = map.allKeys.firstObject;UIImage *value = map[key];
    MEBabyProfile *baby = [[MEBabyProfile alloc] initWithNibName:nil bundle:nil];
    MEBaseNavigationProfile *babyNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:baby];
    babyNavi.tabBarItem.title = key;
    babyNavi.tabBarItem.image = value;
    value = [value imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    babyNavi.tabBarItem.selectedImage = value;
    
    map = tabInfos[1];
    key = map.allKeys.firstObject;value = map[key];
    MEGardenProfile *garden = [[MEGardenProfile alloc] initWithNibName:nil bundle:nil];
    MEBaseNavigationProfile *gardenNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:garden];
    gardenNavi.tabBarItem.title = key;
    gardenNavi.tabBarItem.image = value;
    value = [value imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gardenNavi.tabBarItem.selectedImage = value;
    
    map = tabInfos[2];
    key = map.allKeys.firstObject;value = map[key];
    MEPersonalProfile *personal = [[MEPersonalProfile alloc] initWithNibName:nil bundle:nil];
    MEBaseNavigationProfile *personalNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:personal];
    personalNavi.tabBarItem.title = key;
    personalNavi.tabBarItem.image = value;
    value = [value imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalNavi.tabBarItem.selectedImage = value;
    //tabbar
    UIColor *color = pbColorMake(ME_THEME_COLOR_VALUE);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    self.winRootTabProfile = [[MEBaseTabBarProfile alloc] initWithNibName:nil bundle:nil];
    self.winRootTabProfile.viewControllers = @[babyNavi, gardenNavi, personalNavi];
    
    return self.winRootTabProfile;
#endif
    
    UIViewController *destProfile = nil;
    if (valid) {
        
    } else {
        
        ViewController *profile = [[ViewController alloc] init];
        return profile;
        
        
        
        //当前没有可用的user 需要用户重新登录授权
        Class cls = [self class];
        if ([cls instancesRespondToSelector:@selector(ksks)]) {
            
        }
    }
    
    return destProfile;
}

#pragma mark -- handle splash for sence change

- (void)changeDisplayStyle:(uint)style {
    if (style & MEDisplayStyleAuthor) {
        
    } else if (style & MEDisplayStyleMainSence) {
        /*
        NSArray <NSString *>*clss = @[@"MEIndexProfile", @"MEChatSessionProfile", @"MEBabyProfile", @"MEGardenProfile", @"MEPersonalProfile"];
        __block NSMutableArray <Class>* classes = [NSMutableArray arrayWithCapacity:0];
        [clss enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class cls =NSClassFromString(obj);
            [classes addObject:cls];
        }];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor blueColor]];
        [[UITabBar appearance] setTranslucent:false];
        //[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
       self.winRootTabProfile = [MEBaseTabBarProfile barWithSubClasses:classes.copy];
        //*/
        
        MEIndexProfile *index = [[MEIndexProfile alloc] initWithNibName:nil bundle:nil];
        MEBaseNavigationProfile *indexNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:index];
        
        MEBabyProfile *baby = [[MEBabyProfile alloc] initWithNibName:nil bundle:nil];
        MEBaseNavigationProfile *babyNavi = [[MEBaseNavigationProfile alloc] initWithRootViewController:baby];
        babyNavi.tabBarItem.title = @"baby";
        
        self.winRootTabProfile = [[MEBaseTabBarProfile alloc] initWithNibName:nil bundle:nil];
        self.winRootTabProfile.viewControllers = @[indexNavi, babyNavi];
        
        [self.winProfile setViewControllers:@[self.winRootTabProfile] animated:true];
    }
}

@end
