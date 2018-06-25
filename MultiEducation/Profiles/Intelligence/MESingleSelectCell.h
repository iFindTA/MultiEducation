//
//  MESingleSelectCell.h
//  MultiIntelligent
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MESingleSelectCell : MEBaseCell
@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@end
