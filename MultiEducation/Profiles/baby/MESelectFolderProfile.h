//
//  MESelectFolderProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"

typedef void(^MoveSuccCallback)(void);

@interface MESelectFolderProfile : MEBaseProfile

@property (nonatomic, copy) MoveSuccCallback moveSuccCallback;

@end
