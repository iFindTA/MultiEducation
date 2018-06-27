//
//  MENurseryVM.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MeschoolAddress.pbobjc.h"

@interface MENurseryVM : MEVM

+ (instancetype)vmWithPB:(SchoolAddressListPb *)pb;

@end
