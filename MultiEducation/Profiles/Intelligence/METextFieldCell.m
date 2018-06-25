//
//  METextFieldCell.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METextFieldCell.h"
#import <IQKeyboardManager.h>

@implementation METextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.input.delegate = self;
    IQKeyboardManager.sharedManager.enable = true;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
