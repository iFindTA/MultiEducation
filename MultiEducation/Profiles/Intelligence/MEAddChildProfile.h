//
//  MEAddChildProfile.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"

@interface MEAddChildProfile : MEBaseProfile

@property (nonatomic, copy) void(^didAddChildSuccessCallback) (void);

@end