//
//  MEVideoRelateVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"

@class MEPlayInfoTitlePanel;
@interface MEVideoRelateVM : MEVM

/**
 video relative touch callback
 */
@property (nonatomic, copy) void(^videoRelativeCallback)(NSString *vid);

/**
 class method for instance
 */
+ (instancetype)vmWithRelateVideoID:(NSString *)vid table:(UITableView *)table;

/**
 load
 */
- (void)loadRelateVideos;

/**
 update relate datas;
 */
- (void)updateRelativeDatas;

@end
