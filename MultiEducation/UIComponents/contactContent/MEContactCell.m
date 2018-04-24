//
//  MEContactCell.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEContactCell.h"

@interface MEContactCell ()

@property (nonatomic, strong) MEBaseScene *infoScene;

@end

@implementation MEContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infoScene];
        
        [self.infoScene addSubview:self.sectionLab];
        
        [self.infoScene addSubview:self.icon];
        
        [self.infoScene addSubview:self.infoLab];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    weakify(self)
    [self.infoScene makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.contentView);
    }];
    [self.sectionLab makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.bottom.equalTo(self.infoScene);
        make.width.equalTo(ME_HEIGHT_TABBAR);
    }];
    NSUInteger offset = ME_LAYOUT_MARGIN + ME_LAYOUT_OFFSET;
    NSUInteger iconSize = ME_HEIGHT_TABBAR-offset*2;
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.equalTo(self.infoScene).offset(ME_HEIGHT_TABBAR);
        make.width.height.equalTo(iconSize);
        make.centerY.equalTo(self.infoScene);
    }];
    [self.infoLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.infoScene);
        make.left.equalTo(self.icon.mas_right).offset(ME_LAYOUT_MARGIN*2);
        make.right.equalTo(self.infoScene);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.sectionLab.hidden = false;
    [self.icon sd_cancelCurrentAnimationImagesLoad];
}

#pragma mark --- lazy loading

- (MEBaseScene *)infoScene {
    if (!_infoScene) {
        _infoScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _infoScene;
}

- (MEBaseLabel *)sectionLab {
    if (!_sectionLab) {
        _sectionLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _sectionLab.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
        _sectionLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _sectionLab.textAlignment = NSTextAlignmentCenter;
    }
    return _sectionLab;
}

- (MEBaseLabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _infoLab.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE);
        _infoLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _infoLab;
}

- (MEBaseImageView *)icon {
    if (!_icon) {
        _icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    }
    return _icon;
}

@end
