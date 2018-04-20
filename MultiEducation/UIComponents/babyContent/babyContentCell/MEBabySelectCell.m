//
//  MEBabySelectCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabySelectCell.h"
#import "AppDelegate.h"

@implementation MEBabySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(StudentPb *)student {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *urlStr = [NSString stringWithFormat: @"%@%@", delegate.curUser.bucketDomain, student.portrait];
    [self.icon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed:@"appicon_placeholder"]];
    
    self.nameLabel.text = student.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
