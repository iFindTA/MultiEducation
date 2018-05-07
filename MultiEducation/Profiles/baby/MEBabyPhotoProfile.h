//
//  MEBabyPhotoProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"

@interface MEBabyPhotoProfile : MEBaseProfile

@property (nonatomic, copy) void(^DidChangePhotoCallback)(void);

@end
