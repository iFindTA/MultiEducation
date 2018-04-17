//
//  MEVerifyCodeVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"
#import "MesignIn.pbobjc.h"

@interface MEVerifyCodeVM : MEVM

+ (instancetype)vmWithPB:(MEPBSignIn *)pb;

@end
