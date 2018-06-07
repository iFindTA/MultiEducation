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
#import "MebabyGrowth.pbobjc.h"

@implementation MEBabyHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.currentUser.portrait];
    
    [self.userHeadIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        if (self.currentUser.parentsPb.studentPbArray.count < 2) {
            self.settingBtn.hidden = YES;
            if (self.currentUser.parentsPb.studentPbArray.count == 0) {
                self.userNameLab.text = self.currentUser.name;
                self.ageLab.text = @"--";
                self.babyHeightLab.text = @"--";
                self.babyWeightLab.text = @"--";
            }
        }
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

- (void)setData:(GuStudentArchivesPb *)growthPb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.curUser.userType == MEPBUserRole_Parent) {
        self.ageLab.text = [NSString stringWithFormat: @"%d岁", growthPb.age];
        self.babyHeightLab.text = [NSString stringWithFormat: @"%.1fcm", growthPb.height];
        self.babyWeightLab.text = [NSString stringWithFormat: @"%.1fkg", growthPb.weight];
        if (![growthPb.studentPortrait isEqualToString: @""]) {
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, growthPb.studentPortrait];
            [self.userHeadIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
        }
        
        NSString *text;
        NSString *babyName = growthPb.studentName;
        if ([babyName isEqualToString: @""]) {
            text = self.currentUser.name;
        } else {
            text = [NSString stringWithFormat: @"%@家长，您好！", babyName];
        }
        self.userNameLab.text = text;
    }
}

- (IBAction)settingTouchEvent:(MEBaseButton *)sender {
    void(^callBack)(StudentPb *pb) = ^(StudentPb *pb){
        if (self.selectCallBack) {
            self.selectCallBack(pb);
        }
    };
    
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK: callBack};
    NSString *urlStr = @"profile://root@MEBabySelectProfile";
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}


@end
