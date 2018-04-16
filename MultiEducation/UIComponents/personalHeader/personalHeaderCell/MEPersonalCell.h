//
//  MEPersonalCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEPersonalCell : MEBaseCell

@property (weak, nonatomic) IBOutlet MEBaseLabel *textLab;

- (void)setData:(NSString *)text;

@end
