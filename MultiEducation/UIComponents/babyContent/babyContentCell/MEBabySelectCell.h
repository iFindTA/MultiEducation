//
//  MEBabySelectCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEBabySelectCell : MEBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet MEBaseLabel *nameLabel;

- (void)setData:(StudentPb *)student;

@end
