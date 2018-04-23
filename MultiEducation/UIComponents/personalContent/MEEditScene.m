//
//  MEEditScene.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEEditScene.h"

@implementation MEEditScene

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textfield.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textfield resignFirstResponder];
    return YES;
}

@end