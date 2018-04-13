//
//  UITextField+MaxLength.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UITextField (MaxLength)

@property (assign, nonatomic) IBInspectable NSUInteger maxLength;

@end
