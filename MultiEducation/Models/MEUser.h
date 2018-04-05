//
//  MEUser.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEConstTypes.h"

@interface MEUser : NSObject

@property (nonatomic, assign) MEUserRole    role;

@property (nonatomic, assign) MEUserState   state;

@property (nonatomic, assign) NSTimeInterval signtimestamp;

@end
