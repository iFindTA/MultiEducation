//
//  MEMultiBabyCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
@class MEStudentModel;

@interface MEMultiBabyCell : MEBaseCell

@property (weak, nonatomic) IBOutlet MEBaseLabel *searchLab;

@property (weak, nonatomic) IBOutlet MEBaseImageView *portrait;

@property (weak, nonatomic) IBOutlet MEBaseLabel *nameLab;

@property (weak, nonatomic) IBOutlet MEBaseImageView *statusImageView;


- (void)setData:(MEStudentModel *)model;

@end
