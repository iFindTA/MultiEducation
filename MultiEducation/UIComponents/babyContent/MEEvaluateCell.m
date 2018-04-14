//
//  MEEvaluateCell.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEEvaluateCell.h"
#import "MEEvaluateSelectItem.m"
#define  question_font    14
#define  leftDistance     10

@implementation MEEvaluateCell
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setUI {
    MEBaseLabel *questionLabel = [[MEBaseLabel alloc] init];
    questionLabel.textColor = UIColorFromRGB(0x333333);
    questionLabel.font = UIFontPingFangSC(question_font);
    questionLabel.text = @"ouiewyuyoaeguiwiuegipudaeiusgdugaweyd7awetdwetdwe7wewe78t";
    [self.contentView addSubview:questionLabel];
    weakify(self);
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.equalTo(self.contentView.mas_left).with.offset(leftDistance);
        make.top.equalTo(self.contentView.mas_top).with.offset(leftDistance);
    }];
    
    MEEvaluateSelectItem *selectedItem = [[MEEvaluateSelectItem alloc] initWithFrame:CGRectMake(0, 0, leftDistance, leftDistance) withTitle:@"jewhuewui"];
    [self addSubview:selectedItem];
    [selectedItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(questionLabel.mas_left);
        make.right.mas_equalTo(questionLabel.mas_right);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
