//
//  MESingleSelectCell.m
//  MultiIntelligent
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESingleSelectCell.h"

@implementation MESingleSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstBtn.selected = true;
    self.firstBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.firstBtn.layer.borderWidth = 0.f;
    self.firstBtn.layer.cornerRadius = self.firstBtn.frame.size.height / 2;
    self.firstBtn.layer.masksToBounds = true;

    self.secondBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.secondBtn.layer.borderWidth = 1.f;
    self.secondBtn.layer.cornerRadius = self.secondBtn.frame.size.height / 2;
    self.secondBtn.layer.masksToBounds = true;
    
    [self.firstBtn setBackgroundImage: [UIImage pb_imageWithColor: UIColorFromRGB(ME_THEME_COLOR_VALUE)] forState: UIControlStateSelected];
    [self.firstBtn setBackgroundImage: [UIImage pb_imageWithColor: [UIColor whiteColor]] forState: UIControlStateNormal];
    [self.secondBtn setBackgroundImage: [UIImage pb_imageWithColor: UIColorFromRGB(ME_THEME_COLOR_VALUE)] forState: UIControlStateSelected];
    [self.secondBtn setBackgroundImage: [UIImage pb_imageWithColor: [UIColor whiteColor]] forState: UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)didTouchMale:(MEBaseButton *)sender {
    _secondBtn.selected = sender.selected;
    sender.selected = !sender.selected;
    [self changeBtnBorderLayer];
}

- (IBAction)didTouchFemale:(MEBaseButton *)sender {
    _firstBtn.selected = sender.selected;
    sender.selected = !sender.selected;
    [self changeBtnBorderLayer];
}

- (void)changeBtnBorderLayer {
    if (self.firstBtn.selected) {
        self.firstBtn.layer.borderWidth = 0;
        self.secondBtn.layer.borderWidth = 1;
    } else {
        self.secondBtn.layer.borderWidth = 0;
        self.firstBtn.layer.borderWidth = 1;
    }
}


@end
