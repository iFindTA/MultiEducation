//
//  MEVideoRelateVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoRelateVM.h"

@interface MEVideoRelateVM ()

@property (nonatomic, copy) NSString *vid;
@property (nonatomic, weak) UITableView *weakTable;

@end

@implementation MEVideoRelateVM

+ (instancetype)vmWithRelateVideoID:(NSString *)vid table:(UITableView *)table {
    MEVideoRelateVM *vm = [[MEVideoRelateVM alloc] init];
    vm.vid = vid.copy;
    vm.weakTable = table;
    return vm;
}

- (void)loadRelateVideos {
    
}

@end
