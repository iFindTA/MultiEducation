//
// Created by nanhu on 2018/4/3.
// Copyright (c) 2018 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "AppDelegate.h"
#import "MEBaseScene.h"
#import "MEDispatcher.h"
#import "MEUIBaseHeader.h"
#import "MEBaseTableView.h"
#import <PBService/PBService.h>
#import <PBBaseClasses/PBBaseProfile.h>
#import <UIViewController+SJVideoPlayerAdd.h>
#import <UMCAnalytics/UMAnalytics/MobClick.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEBaseProfile : PBBaseProfile

/**
 切换授权中心与主界面
 */
- (void)splash2ChangeDisplayStyle:(MEDisplayStyle)style;

#pragma mark --- Appliccation StatuBar

#pragma mark -- Root TabBar Actions

/**
 *  @brief hidden/show root tabbar
 *
 *  @param hidden   wether hidden
 *  @param animated wether animated
 *  @Attentions:    this function need AppDelegate Class support '- (FLKBaseTabBarController *)rootTabBar' method
 *
 */
- (void)hideTabBar:(BOOL)hidden animated:(BOOL)animated;

/**
 *  @brief update tabBar's item badge value
 *
 *  @param value the value
 *  @param idx   the item's index
 */
- (void)setBadgeValue:(NSInteger)value atIndex:(NSUInteger)idx;
- (void)clearBadgeAtIndex:(NSUInteger)idx;

/**
 goback stack before some class

 @param aClass dest class
 */
- (void)backStackBeforeClass:(Class)aClass;

#pragma mark --- user relatives

/**
 fetch current profile that topest!
 */
- (UIViewController *)topestProfile;

- (AppDelegate *)appDelegate;

/**
 getter current user
 */
- (MEPBUser * _Nullable)currentUser;

/**
 show toast
 */
- (void)makeToast:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
