//
//  MEParentsInfoView.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/4.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEParentsInfoView : MEBaseScene <UITextFieldDelegate>

@property (nonatomic, strong) MEBaseLabel *tipLab;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *addressTextField;

@end
