//
//  MEPlayInfoTitlePanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUIBaseHeader.h"
#import "MEPlayInfoTitlePanel.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface MEPlayInfoTitlePanel ()

@property (nonatomic, strong) MEBaseLabel *titleLab;
@property (nonatomic, strong) TTGTextTagCollectionView *tagScene;

@end

@implementation MEPlayInfoTitlePanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //title
        UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
        self.titleLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        self.titleLab.font = font;
        //self.titleLab.text = title;
        self.titleLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        [self addSubview:self.titleLab];
        
        //label tags
        //NSArray *tags = @[@"大班上",@"故事",@"亲子"];
        UIFont *tagFont = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
        TTGTextTagConfig *cfg = [[TTGTextTagConfig alloc] init];
        cfg.tagTextFont = tagFont;
        cfg.tagTextColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        cfg.tagBackgroundColor = UIColorFromRGB(0xF5F5F5);
        cfg.tagBorderWidth = 0.f;
        cfg.tagExtraSpace = CGSizeMake(ME_LAYOUT_MARGIN*2, ME_LAYOUT_MARGIN);
        TTGTextTagCollectionView *tagScene = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectZero];
        tagScene.contentInset = UIEdgeInsetsMake(3, 0, 2, 0);
        tagScene.defaultConfig = cfg;
        tagScene.enableTagSelection = false;
        //tagScene.backgroundColor = [UIColor redColor];
        tagScene.userInteractionEnabled = false;
        tagScene.alignment = TTGTagCollectionAlignmentRight;
        [self addSubview:tagScene];
        self.tagScene = tagScene;
        //[tagScene addTags:tags];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN * 2);
        make.height.equalTo(ME_HEIGHT_TABBAR);
    }];
    
    [self.tagScene makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, 0, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN));
        make.top.equalTo(self).offset(ME_LAYOUT_MARGIN * 2);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN *2);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
}

- (void)updatePlayInfoTitlePanel4Info:(NSDictionary *)titleMap {
    //TODO://更新UI
    [self.tagScene removeAllTags];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
