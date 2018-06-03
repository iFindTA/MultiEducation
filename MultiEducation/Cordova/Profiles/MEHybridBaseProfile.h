//
//  MEHybridBaseProfile.h
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "MEKits.h"
#import "CDVViewController.h"
#import <PBService/PBService.h>
#import <PBBaseClasses/PBNavigationBar.h>
#import <UIViewController+SJVideoPlayerAdd.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEHybridBaseProfile : CDVViewController

/**
 custom navigationBar
 */
@property (nonatomic, strong, readonly, nullable) PBNavigationBar *navigationBar;

/**
 run path
 */
- (NSString *)wwwFolderPath;

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
