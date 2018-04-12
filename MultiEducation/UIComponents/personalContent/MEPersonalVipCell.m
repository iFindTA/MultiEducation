//
//  MEPersonalVipCell.m
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalVipCell.h"

@implementation MEPersonalVipCell
{
    MEBaseLabel *_titleLabel;
    MEBaseLabel *_timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, vip_cell_height)];
        contentView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:contentView];
        
        UIImage *vipImage = [UIImage imageNamed:@"personal_vip_icon"];
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.image = vipImage;
        [contentView addSubview:vipView];
        [vipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(vipImage.size.width, vipImage.size.height));
        }];
        
        _titleLabel = [[MEBaseLabel alloc] init];
        [contentView addSubview:_titleLabel];
        _titleLabel.text = @"我的会员";
        _titleLabel.textColor = UIColorFromRGB(0xD1B27D);
        _titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.equalTo(vipView.right).with.offset(10);
        }];
        
        UIImage *arrowImage = [UIImage imageNamed:@"personal_right_vip_arrows_icon"];
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = arrowImage;
        [contentView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.centerY);
            make.right.equalTo(contentView.right).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(arrowImage.size.width, arrowImage.size.height));
        }];
        
        _timeLabel = [[MEBaseLabel alloc] init];
        [contentView addSubview:_timeLabel];
        _timeLabel.textColor = UIColorFromRGB(0xD1B27D);
        _timeLabel.text = @"您的会员2013-09-07到期";
        _timeLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.right.equalTo(arrowView.left).with.offset(-10);
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
