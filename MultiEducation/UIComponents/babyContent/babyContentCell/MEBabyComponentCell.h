//
//  MEBabyComponentCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"
#import "MEBabyContent.h"

@interface MEBabyComponentCell : MEBaseCollectionCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet MEBaseLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet MEBaseLabel *badageLab;

- (void)setItemWithType:(MEBabyContentType)type badge:(NSInteger)badge whetherGraduate:(BOOL)graduate;

@end
