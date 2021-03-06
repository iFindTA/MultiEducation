//
//  MECardCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"
@class GuFunPhotoPb;

@interface MECardCell : MEBaseCollectionCell
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;

@property (weak, nonatomic) IBOutlet MEBaseImageView *coverImage;
@property (weak, nonatomic) IBOutlet MEBaseLabel *countLab;
@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;
@property (weak, nonatomic) IBOutlet MEBaseLabel *subtitleLab;
@property (weak, nonatomic) IBOutlet MEBaseLabel *markLab;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic, copy) void(^gotoPhotoBrowserHandler) (GuFunPhotoPb *pb);
@property (nonatomic, copy) void(^didDeleteBabyFunSuccessCallback) ();

- (void)setData:(GuFunPhotoPb *)pb;

@end
