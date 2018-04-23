//
//  MEHeaderIconCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
#import "Meuser.pbobjc.h"

@interface MEHeaderIconCell : MEBaseCell

@property (weak, nonatomic) IBOutlet MEBaseLabel *textLab;

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

- (void)setData:(MEPBUser *)userPb;


@end