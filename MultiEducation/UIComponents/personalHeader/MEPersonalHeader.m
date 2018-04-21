//
//  MEPersonalHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPersonalHeader.h"

@implementation MEPersonalHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setData];
}

- (void)setData {
    NSString *urlStr = [NSString stringWithFormat: @"%@%@", self.currentUser.bucketDomain, self.currentUser.portrait];
    [self.userIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    self.userName.text = self.currentUser.name;
    self.userSign.text = @"个性签名";
}


- (IBAction)settingTouchEvent:(MEBaseButton *)sender {
    NSLog(@"did touch setting event");
    
}
@end
