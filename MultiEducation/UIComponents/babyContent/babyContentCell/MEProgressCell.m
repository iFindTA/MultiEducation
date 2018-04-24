//
//  MEProgressCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEProgressCell.h"

@implementation MEProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.retryLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
