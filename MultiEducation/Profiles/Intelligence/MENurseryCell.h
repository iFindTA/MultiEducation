//
//  MENurseryCell.h
//  MultiIntelligent
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
@class SchoolAddressPb;
@class MEPBClass;

@interface MENurseryCell : MEBaseCell

@property (nonatomic, strong) MEBaseLabel *titleLab;
@property (nonatomic, strong) MEBaseLabel *subTitleLab;

- (void)setData:(SchoolAddressPb *)school;

- (void)setDataWithClass:(MEPBClass *)classPb;

@end
