//
//  MEHistoryCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEHistoryCell.h"
#import "AppDelegate.h"

@implementation MEHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(MEWatchItem *)item {
    AppDelegate *delegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *urlStr = [NSString stringWithFormat: @"%@%@", delegate.curUser.bucketDomain, item.filePath];
    [self.videoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"index_content_placeholder"]];
    
    self.videoName.text = item.title;
}

@end
