//
//  MEBabyPhotoHeader.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef void(^BabyPhotoHeaderCallBack)(NSInteger index);

@interface MEBabyPhotoHeader : MEBaseScene

- (instancetype)initWithTitles:(NSArray *)titles;

@property (nonatomic, copy) BabyPhotoHeaderCallBack babyPhotoHeaderCallBack;

- (void)markLineAnimation:(NSInteger)page;

@end
