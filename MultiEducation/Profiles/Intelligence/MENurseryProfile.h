//
//  MENurseryProfile.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"
@class SchoolAddressPb;
@class MEPBClass;

@interface MENurseryProfile : MEBaseProfile

@property (nonatomic, copy) void (^didSelectSchoolCallback) (SchoolAddressPb *school, MEPBClass *classPb);

@end
