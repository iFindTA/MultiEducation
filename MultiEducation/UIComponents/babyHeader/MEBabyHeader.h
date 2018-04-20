//
//  MEChatHeader.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"


typedef void(^settingCallBack)(void);

@interface MEBabyHeader : MEBaseScene

@property (weak, nonatomic) IBOutlet UIImageView *backContentView;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadIcon;

@property (weak, nonatomic) IBOutlet MEBaseLabel *userNameLab;

@property (weak, nonatomic) IBOutlet MEBaseButton *settingBtn;


@property (weak, nonatomic) IBOutlet MEBaseLabel *ageTipLabel;

@property (weak, nonatomic) IBOutlet MEBaseLabel *ageLab;

@property (weak, nonatomic) IBOutlet MEBaseLabel *babyHeightTipLabel;

@property (weak, nonatomic) IBOutlet MEBaseLabel *babyHeightLab;

@property (weak, nonatomic) IBOutlet MEBaseLabel *babyWeightTipLabel;

@property (weak, nonatomic) IBOutlet MEBaseLabel *babyWeightLab;





@end
