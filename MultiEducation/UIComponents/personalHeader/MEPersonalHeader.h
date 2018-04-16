//
//  MEPersonalHeader.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEPersonalHeader : MEBaseScene

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet MEBaseLabel *userName;

@property (weak, nonatomic) IBOutlet MEBaseLabel *userSign;

@property (weak, nonatomic) IBOutlet MEBaseButton *settingButton;


@end
