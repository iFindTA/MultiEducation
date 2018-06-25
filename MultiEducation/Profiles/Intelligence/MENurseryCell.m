//
//  MENurseryCell.m
//  MultiIntelligent
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENurseryCell.h"

@implementation MENurseryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)customSubviews {
    
    _titleLab = [[MEBaseLabel alloc] init];
    _titleLab.font = UIFontPingFangSC(15);
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10.f);
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(54.f);
        [self.titleLab sizeToFit];
    }];
    
    _subTitleLab = [[MEBaseLabel alloc] init];
    _subTitleLab.font = UIFontPingFangSC(12);
    _subTitleLab.textColor = UIColorFromRGB(0x666666);
    _subTitleLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(10.f);
        make.centerY.mas_equalTo(self.titleLab);
        make.height.mas_equalTo(20.f);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10.f);
    }];
    
    
    
}



@end
