//
//  MEIndexContentTitleCell.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/12.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexContentTitleCell.h"

@implementation MEIndexContentTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.rightScene.hidden = false;
}
- (IBAction)indexContentItemLeftTouchEvent:(id)sender {
    if (self.MEIndexItemCallback) {
        self.MEIndexItemCallback(self.tag, self.leftScene.tag);
    }
}
- (IBAction)indexContentItemRightTouchEvent:(id)sender {
    if (self.MEIndexItemCallback) {
        self.MEIndexItemCallback(self.tag, self.rightScene.tag);
    }
}

@end
