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
    [self addShadow];
}
 
#pragma mark-添加阴影
- (void)addShadow {
//    self.layer.shadowPath =[UIBezierPath bezierPathWithRect: self.bounds].CGPath;
    self.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(-3.0, 3.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected: selected];
}

@end