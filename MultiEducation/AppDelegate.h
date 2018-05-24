//
//  AppDelegate.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEPBUser, MEBaseNavigationProfile, MEBaseTabBarProfile;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 root navigation-profile
 */
@property (nonatomic, strong, readonly) MEBaseNavigationProfile * winProfile;

/**
 the user view model who did signed-in
 */
@property (nonatomic, strong, readonly, nullable) MEPBUser * curUser;

- (UIView *)rootView;

/**
 splash change display sence
 */
- (void)changeDisplayStyle:(uint)style;

/**
 更新当前登录用户
 */
- (void)updateCurrentSignedInUser:(MEPBUser * _Nullable)usr;

/**
 被动登出（账号被登录）
 */
- (void)passiveLogout:(NSString *_Nullable)msg;

/**
 开启即时服务: {融云IM，自身长链接}
 */
- (void)startIMServivesOnBgThread;

/**
 更新当前未读消息数
 */
- (void)updateRongIMUnReadMessageCounts;

@end

NS_ASSUME_NONNULL_END
