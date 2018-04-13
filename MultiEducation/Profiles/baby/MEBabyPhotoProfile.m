//
//  MEBabyPhotoProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoProfile.h"
#import "MEBabyPhotoHeader.h"

#define TITLES @[@"照片", @"时间轴"]

@interface MEBabyPhotoProfile ()

@property (nonatomic, strong) MEBabyPhotoHeader *header;

@end

@implementation MEBabyPhotoProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - lazyloading
- (MEBabyPhotoHeader *)header {
    if (!_header) {
        _header = [[MEBabyPhotoHeader alloc] initWithTitles: TITLES];
    }
    return _header;
}



@end
