//
//  MEPersonalCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPersonalCell.h"

@implementation MEPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)text {
    self.textLab.text = text;
}

- (void)setData:(NSString *)text hidden:(BOOL)hide {
    [self setData: text];
    self.rightIcon.hidden = hide;
}

@end
