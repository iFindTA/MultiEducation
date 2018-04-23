//
//  MEHybridBaseProfile.h
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "CDVViewController.h"
#import <PBBaseClasses/PBNavigationBar.h>
#import <UIViewController+SJVideoPlayerAdd.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEHybridBaseProfile : CDVViewController

/**
 custom navigationBar
 */
@property (nonatomic, strong, readonly, nullable) PBNavigationBar *navigationBar;

/**
 root web folder
 */
- (NSString *)wwwFolderPath;

/**
 spacer for bar
 */
- (UIBarButtonItem *)barSpacer;

/**
 back bar
 */
- (UIBarButtonItem *)backBarWithColor:(UIColor * _Nullable)color;

/**
 bar button item
 */
- (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color eventSelector:(nullable SEL)selector;

/**
 bar button item
 */
- (UIBarButtonItem *)barWithTitle:(NSString *)title color:(UIColor *)color eventSelector:(nullable SEL)selector;

/**
 导航条返回事件 交予JavaScript
 */
- (void)cordovaNavigationBackEvent;

/**
 更新导航条右边标题 回调方法名
 */
- (void)updateMoreActionTitle:(NSString *)title callbackMethod:(NSString *)callback;

@end

NS_ASSUME_NONNULL_END
