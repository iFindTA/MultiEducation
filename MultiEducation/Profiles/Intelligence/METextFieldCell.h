//
//  METextFieldCell.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface METextFieldCell : MEBaseCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextField *input;

- (void)updateLayout;

@end
