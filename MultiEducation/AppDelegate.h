//
//  AppDelegate.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEUserVM, MEBaseNavigationProfile;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 root navigation-profile
 */
@property (nonatomic, strong, readonly) MEBaseNavigationProfile * winProfile;

/**
 the user view model who did signed-in
 */
@property (nonatomic, strong, readonly, nullable) MEUserVM * curUser;

/**
 splash change display sence
 */
- (void)changeDisplayStyle:(uint)style;

@end

NS_ASSUME_NONNULL_END
