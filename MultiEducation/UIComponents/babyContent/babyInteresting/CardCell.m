//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CardCell.h"

@interface CardCell ()

@end

@implementation CardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.contentView.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected: selected];
}

@end
