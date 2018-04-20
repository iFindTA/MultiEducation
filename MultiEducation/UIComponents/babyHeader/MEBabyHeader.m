//
//  MEChatHeader.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyHeader.h"
#import "UIView+BlurEffect.h"

@implementation MEBabyHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
   
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect: effect];
    [_backContentView addSubview: effectView];
    
    //layout;
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        self.ageLab.hidden = YES;
        self.ageTipLabel.hidden = YES;
        self.babyHeightLab.hidden = YES;
        self.babyHeightTipLabel.hidden = YES;
        self.babyWeightLab.hidden = YES;
        self.babyWeightTipLabel.hidden = YES;
    }
    
    
    
}

- (IBAction)settingTouchEvent:(MEBaseButton *)sender {
    NSLog(@"click setting event");
}


@end
