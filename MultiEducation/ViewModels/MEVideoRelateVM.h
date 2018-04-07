//
//  MEVideoRelateVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"

@interface MEVideoRelateVM : MEVM <UITableViewDataSource>

+ (instancetype)vmWithRelateVideoID:(NSString *)vid table:(UITableView *)table;

- (void)loadRelateVideos;

@end
