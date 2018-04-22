//
//  MEHybridBaseProfile.h
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "CDVViewController.h"
#import <PBBaseClasses/PBNavigationBar.h>

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

@end

NS_ASSUME_NONNULL_END
