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

- (UIViewController *)assembleRootProfileWhileUserValid:(BOOL)valid {
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
    
}

@end
