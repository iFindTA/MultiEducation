//
//  MEAddChildVM.h
//  MultiIntelligent
//
//  Created by cxz on 2018/6/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
@class StudentPb;

@interface MEAddChildVM : MEVM

+ (instancetype)vmWithPB:(StudentPb *)pb;

@end
