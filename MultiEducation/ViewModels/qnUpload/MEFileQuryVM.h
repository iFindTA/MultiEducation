//
//  MEFileQuryVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meqnfile.pbobjc.h"

@interface MEFileQuryVM : MEVM

+ (instancetype)vmWithPb:(MEPBQNFile *)qnPb;

@end
