//
//  MEMultiBabyCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMultiBabyCell.h"
#import "MEStudentModel.h"

@implementation MEMultiBabyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusImageView.userInteractionEnabled = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setData:(MEStudentModel *)model {
    [self changeStatus: model.status];
}

- (void)changeStatus:(SelectStatus)status {
    if (status == CantSelect) {
        self.statusImageView.image = [UIImage imageNamed: @"baby_interesting_cant_sel"];
    } else if (status == Selected) {
        self.statusImageView.image = [UIImage imageNamed: @"baby_interesting_sel"];
    } else {
        self.statusImageView.image = [UIImage imageNamed: @"baby_interesting_nor"];
    }
}

@end
