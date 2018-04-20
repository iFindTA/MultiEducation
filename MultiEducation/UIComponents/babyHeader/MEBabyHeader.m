//
//  MEChatHeader.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyHeader.h"
#import "UIView+BlurEffect.h"
#import "MEBabySelectProfile.h"

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
    
    NSString *urlStr = [NSString stringWithFormat: @"%@%@", self.currentUser.bucketDomain, self.currentUser.portrait];
    
    [self.userHeadIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        if (self.currentUser.parentsPb.studentPbArray.count < 2) {
            self.settingBtn.hidden = YES;
            if (self.currentUser.parentsPb.studentPbArray.count == 0) {
                self.ageLab.text = @"--";
                self.babyHeightLab.text = @"--";
                self.babyWeightLab.text = @"--";
            }
        }
        self.userNameLab.text = [NSString stringWithFormat: @"%@，您好", self.currentUser.name];
    }
    
    if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
        self.ageLab.hidden = YES;
        self.ageTipLabel.hidden = YES;
        self.babyHeightLab.hidden = YES;
        self.babyHeightTipLabel.hidden = YES;
        self.babyWeightLab.hidden = YES;
        self.babyWeightTipLabel.hidden = YES;

        self.userNameLab.text = [NSString stringWithFormat: @"欢迎来到%@", self.currentUser.schoolName];
        
        self.settingBtn.hidden = YES;
    }
}

- (IBAction)settingTouchEvent:(MEBaseButton *)sender {
    NSString *urlString = @"profile://root@MEBabySelectProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: nil];
    [self handleTransitionError:err];
}


@end
