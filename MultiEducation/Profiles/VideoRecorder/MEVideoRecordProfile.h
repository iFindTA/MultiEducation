//
//  MEVideoRecordProfile.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"

typedef void(^MEVideoRecordBlock)(NSString * filePath, CGFloat duration);

@interface MEVideoRecordProfile : MEBaseProfile

- (void)handleVideoRecordCallback:(MEVideoRecordBlock)block;

@end
