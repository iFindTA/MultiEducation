//
//  PBBaseTabBarProfile+Hidden.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBBaseTabBarProfile.h"

@interface PBBaseTabBarProfile (Hidden)

NS_ASSUME_NONNULL_BEGIN

@property(nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
@property(nonatomic, readonly, getter=isTabBarAnimating) BOOL tabBarAnimating;

/**
 hidden/show tabBar's bar
 
 @param hidden wether hidden
 @param animated wether animated
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(void))completion;

//
// NOTE:
// For above methods, default delaysContentResizing = NO.
// Set delaysContentResizing=YES when stretching UITableView, which often clips bottom content on bounds-change.

/**
 hidden/show tabBar's bar
 
 @param hidden wether hidden
 @param animated wether animated
 @param delaysContentResizing wether delay resize
 @param completion block
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(nullable void (^)(void))completion;

NS_ASSUME_NONNULL_END

@end
