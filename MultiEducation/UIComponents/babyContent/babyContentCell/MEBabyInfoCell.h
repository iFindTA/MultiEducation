//
//  MEBabyInfoCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
#import "MenewsInfo.pbobjc.h"

@interface MEBabyInfoCell : MEBaseCell


@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

- (void)setData:(OsrInformationPb *)pb;

@end
