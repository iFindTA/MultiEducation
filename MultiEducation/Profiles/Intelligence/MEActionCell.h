//
//  MEActionCell.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEActionCell : MEBaseCell
@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;
@property (weak, nonatomic) IBOutlet MEBaseLabel *subtitleLab;

- (void)setSubtitleText:(NSString *)text;

@end
