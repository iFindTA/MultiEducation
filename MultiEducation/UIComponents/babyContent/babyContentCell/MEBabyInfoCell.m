//
//  MEBabyInfoCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInfoCell.h"
#import "AppDelegate.h"

@implementation MEBabyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(OsrInformationPb *)pb {
    
    AppDelegate *delegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.titleLab.text = pb.title;
    NSString *urlStr = [NSString stringWithFormat: @"%@/%@", delegate.curUser.bucketDomain, pb.coverImg];
    [self.coverImage sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
