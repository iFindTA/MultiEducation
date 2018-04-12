//
//  MEPersonalListCell.m
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalListCell.h"
#import "MEMacros.h"

@implementation MEPersonalListCell
{
    MEBaseLabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, default_cell_height)];
        contentView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:contentView];
        
        _titleLabel = [[MEBaseLabel alloc] init];
        [contentView addSubview:_titleLabel];
        _titleLabel.text = @"聊天";
        _titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.mas_equalTo(20);
        }];
        
        UIImage *arrowImage = [UIImage imageNamed:@"personal_right_arrows_icon"];
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = arrowImage;
        [contentView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.centerY);
            make.right.equalTo(contentView.right).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(arrowImage.size.width, arrowImage.size.height));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.equalTo(self.mas_bottom).with.offset(-1);
            make.right.mas_equalTo(contentView.right);
            make.height.mas_equalTo(.5);
        }];
    }
    
    return self;
}

- (void)setCellModel:(MEPersonalListModel *)cellModel {
    _titleLabel.text = cellModel.cellTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
