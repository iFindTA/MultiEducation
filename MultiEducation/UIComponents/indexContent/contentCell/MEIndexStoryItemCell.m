//
//  MEIndexStoryItemCell.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexStoryItemCell.h"

static NSUInteger ME_INDEX_STORY_ITEM_TITLE_HEIGHT                              =   30;

@interface MEIndexStoryItemCell ()

@property (nonatomic, strong) MASConstraint *sectionConstraint;
@property (nonatomic, strong) MEBaseScene *sectionScene;

@end

@implementation MEIndexStoryItemCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.marginScene];
        [self.marginScene addSubview:self.sectionScene];
        [self.sectionScene addSubview:self.sectionTitleLab];
        [self.marginScene addSubview:self.middleSeperator];
        [self.marginScene addSubview:self.leftItemScene];
        [self.marginScene addSubview:self.rightItemScene];
        //left
        [self.leftItemScene addSubview:self.leftItemLabel];
        [self.leftItemScene addSubview:self.leftItemImage];
        //right
        [self.rightItemScene addSubview:self.rightItemLabel];
        [self.rightItemScene addSubview:self.rightItemImage];
        //layout
        [self.marginScene makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        NSUInteger itemHeight = adoptValue(ME_INDEX_STORY_ITEM_TITLE_HEIGHT);
        [self.sectionScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.marginScene);
            make.left.equalTo(self.marginScene).offset(ME_LAYOUT_MARGIN * 2);
            make.right.equalTo(self.marginScene);
            make.height.equalTo(0);
        }];
        [self.sectionTitleLab makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.sectionScene);
        }];
        //[self.sectionConstraint deactivate];
        [self.middleSeperator makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.marginScene.mas_bottom);
            make.centerX.equalTo(self.marginScene.mas_centerX);
            make.bottom.equalTo(self.marginScene);
            make.width.equalTo(ME_LAYOUT_MARGIN * 2);
        }];
        
        [self.leftItemScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sectionScene.mas_bottom);
            make.bottom.equalTo(self.marginScene);
            make.right.equalTo(self.middleSeperator.mas_left);
            make.left.equalTo(self.marginScene).offset(ME_LAYOUT_MARGIN * 2);
        }];
        
        [self.leftItemLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.leftItemScene);
            make.right.equalTo(self.middleSeperator.mas_left);
            make.height.equalTo(itemHeight);
        }];
        [self.leftItemImage makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.leftItemScene);
            make.right.equalTo(self.middleSeperator.mas_left);
            make.bottom.equalTo(self.leftItemLabel.mas_top);
        }];
        
        [self.rightItemScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sectionScene.mas_bottom);
            make.bottom.equalTo(self.marginScene);
            make.left.equalTo(self.middleSeperator.mas_right);
            make.right.equalTo(self.marginScene).offset(-ME_LAYOUT_MARGIN * 2);
        }];
        [self.rightItemLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.rightItemScene);
            make.left.equalTo(self.middleSeperator.mas_right);
            make.height.equalTo(itemHeight);
        }];
        [self.rightItemImage makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.rightItemScene);
            make.left.equalTo(self.middleSeperator.mas_right);
            make.bottom.equalTo(self.rightItemLabel.mas_top);
        }];
        //*/
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.rightItemScene.hidden = false;
    //[self.sectionConstraint deactivate];
    NSUInteger itemHeight = adoptValue(ME_INDEX_STORY_ITEM_TITLE_HEIGHT);
    [self.sectionScene updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(itemHeight);
    }];
}

- (void)configureStoryItem4RowIndex:(NSUInteger)row {
    NSUInteger itemHeight = adoptValue(ME_INDEX_STORY_ITEM_TITLE_HEIGHT);
    NSUInteger height = (row == 0?itemHeight:0);
    [self.sectionScene updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [self.marginScene updateConstraints];
}

#pragma mark -- lazy load

- (MEBaseScene *)marginScene {
    if (!_marginScene) {
        _marginScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _marginScene.backgroundColor = [UIColor whiteColor];
    }
    return _marginScene;
}

- (MEBaseScene *)middleSeperator {
    if (!_middleSeperator) {
        _middleSeperator = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _middleSeperator.backgroundColor = [UIColor whiteColor];
    }
    return _middleSeperator;
}

- (MEBaseScene *)sectionScene {
    if (!_sectionScene) {
        _sectionScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _sectionScene.backgroundColor = [UIColor whiteColor];
    }
    return _sectionScene;
}

- (UILabel *)sectionTitleLab {
    if (!_sectionTitleLab) {
        _sectionTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _sectionTitleLab.backgroundColor = [UIColor whiteColor];
        _sectionTitleLab.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
        _sectionTitleLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _sectionTitleLab.text = @"推荐视频";
    }
    return _sectionTitleLab;
}

- (MEBaseScene *)leftItemScene {
    if (!_leftItemScene) {
        _leftItemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _leftItemScene.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemLeftTouchEvent)];
        tapGestuer.numberOfTapsRequired = 1;
        tapGestuer.numberOfTouchesRequired = 1;
        [_leftItemScene addGestureRecognizer:tapGestuer];
    }
    return _leftItemScene;
}

- (MEBaseScene *)rightItemScene {
    if (!_rightItemScene) {
        _rightItemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _rightItemScene.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemRightTouchEvent)];
        tapGestuer.numberOfTapsRequired = 1;
        tapGestuer.numberOfTouchesRequired = 1;
        [_rightItemScene addGestureRecognizer:tapGestuer];
    }
    return _rightItemScene;
}

- (MEBaseImageView *)leftItemImage {
    if (!_leftItemImage) {
        UIImage *image = [UIImage imageNamed:@"index_content_placeholder"];
        _leftItemImage = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        _leftItemImage.image = image;
        _leftItemImage.userInteractionEnabled = true;
    }
    return _leftItemImage;
}

- (MEBaseLabel *)leftItemLabel {
    if (!_leftItemLabel) {
        _leftItemLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _leftItemLabel.backgroundColor = [UIColor whiteColor];
        _leftItemLabel.font = UIFontPingFangSCBold(METHEME_FONT_SUBTITLE);
        _leftItemLabel.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _leftItemLabel.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel.userInteractionEnabled = true;
    }
    return _leftItemLabel;
}

- (MEBaseImageView *)rightItemImage {
    if (!_rightItemImage) {
        UIImage *image = [UIImage imageNamed:@"index_content_placeholder"];
        _rightItemImage = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        _rightItemImage.image = image;
        _rightItemImage.userInteractionEnabled = true;
    }
    return _rightItemImage;
}

- (MEBaseLabel *)rightItemLabel {
    if (!_rightItemLabel) {
        _rightItemLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _rightItemLabel.backgroundColor = [UIColor whiteColor];
        _rightItemLabel.font = UIFontPingFangSCBold(METHEME_FONT_SUBTITLE);
        _rightItemLabel.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _rightItemLabel.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel.userInteractionEnabled = true;
    }
    return _rightItemLabel;
}

#pragma mark --- touch event

- (void)itemLeftTouchEvent {
    if (self.indexContentItemCallback) {
        self.indexContentItemCallback(self.tag, self.leftItemScene.tag);
    }
}

- (void)itemRightTouchEvent {
    if (self.indexContentItemCallback) {
        self.indexContentItemCallback(self.tag, self.rightItemScene.tag);
    }
}

@end
