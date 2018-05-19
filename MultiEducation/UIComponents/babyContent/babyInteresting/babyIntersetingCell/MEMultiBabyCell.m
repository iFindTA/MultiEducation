//
//  MEMultiBabyCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMultiBabyCell.h"

@implementation MEMultiBabyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didSelectButtonTouchEvent:(MEBaseButton *)sender {
    sender.selected = !sender.selected;
}

@end
