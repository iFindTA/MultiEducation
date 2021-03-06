//
//  MEPersonalDataCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEPersonalDataCell : MEBaseCell
@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;

@property (weak, nonatomic) IBOutlet MEBaseLabel *subtitleLab;

- (void)setData:(MEPBUser *)userPb;

- (void)setSubtitleText:(NSString *)text;

@end
