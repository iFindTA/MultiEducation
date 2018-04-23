//
//  MEBabyIndexVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MebabyIndex.pbobjc.h"
#import "MebabyGrowth.pbobjc.h"

@interface MEBabyIndexVM : MEVM

+ (instancetype)vmWithPb:(GuIndexPb *)pb;


/**
 为当前用户 save 选中的宝宝
 
 */
+ (void)saveSelectBaby:(GuIndexPb *)baby;


/**
 获取当前用户保存的  选中的宝宝
 */
+ (GuIndexPb *)fetchSelectBaby;

@end
