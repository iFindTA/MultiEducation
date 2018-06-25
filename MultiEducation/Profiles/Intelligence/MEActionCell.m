//
//  MEActionCell.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEActionCell.h"

@implementation MEActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubtitleText:(NSString *)text {
    if ([text isEqualToString: @"请选择"] || [text isEqualToString: @"请输入"]) {
        self.subtitleLab.textColor = UIColorFromRGB(0x999999);
    } else {
        self.subtitleLab.textColor = UIColorFromRGB(0x333333);
    }
    self.subtitleLab.text = text;
}

@end
