//
//  MEBabyFillBaseLabel.h
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef void(^TextRutrnBlock)(NSString *text);

@interface MEBabyFillBaseLabel : MEBaseScene

@property (nonatomic, copy) TextRutrnBlock textRutrn;
@property (nonatomic, copy) NSString *contentStr;

- (instancetype)initWithWidth:(CGFloat)width withText:(NSString *)text withFont:(CGFloat)font withTextColor:(UIColor *)textColor withCtl:(UIViewController *)ctl;

@end
