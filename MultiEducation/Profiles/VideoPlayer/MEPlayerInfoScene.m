//
//  MEPlayerInfoScene.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayerInfoScene.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface MEPlayerInfoScene ()

@property (nonatomic, strong) NSDictionary *descInfo;

@property (nonatomic, strong) MEBaseLabel *titleLab, *subTitle, *contentLab;

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) TTGTextTagCollectionView *tagScene;

@end

@implementation MEPlayerInfoScene

+ (CGFloat)estimateVideoDescriptionPanelHeight4Description:(NSString *)desc {
    CGFloat height = ME_HEIGHT_TABBAR + ME_LAYOUT_ICON_HEIGHT;
    UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    CGFloat descWidth =MESCREEN_WIDTH - ME_LAYOUT_MARGIN;
    CGSize descSize = [desc pb_sizeThatFitsWithFont:font width:descWidth];
    
    return height + descSize.height + ME_LAYOUT_BOUNDARY;
}

+ (instancetype)configreInfoDescriptionPanelWithInfo:(NSDictionary *)info {
    NSString *descInfo = info[@"desc"];
    CGFloat estimateHeight = [self estimateVideoDescriptionPanelHeight4Description:descInfo];
    CGRect estimateBounds = (CGRect){.origin = CGPointZero, .size = CGSizeMake(MESCREEN_WIDTH, estimateHeight)};
    MEPlayerInfoScene *scene = [[MEPlayerInfoScene alloc] initWithFrame:estimateBounds withDescription:info];
    return scene;
}

- (instancetype)initWithFrame:(CGRect)frame withDescription:(NSDictionary *)map {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.descInfo = [NSDictionary dictionaryWithDictionary:map];
        [self __initVideoPlayDescriptionSubview];
    }
    return self;
}

- (void)__initVideoPlayDescriptionSubview {
    //title
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
    NSString *title = self.descInfo[@"title"];
    self.titleLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    self.titleLab.font = font;
    self.titleLab.text = title;
    self.titleLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    [self addSubview:self.titleLab];
    
    //label tags
    self.tags = @[@"大班上",@"故事",@"亲子"];
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
    [tagScene addTags:self.tags];
    
    //对爸爸妈妈说的话
    font = UIFontPingFangSCBold(METHEME_FONT_TITLE-1);
    self.subTitle = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    self.subTitle.font = font;
    self.subTitle.text = @"对爸爸妈妈说的话：";//此处建议动态获取
    self.subTitle.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    [self addSubview:self.subTitle];
    font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    self.contentLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    self.contentLab.font = font;
    self.contentLab.numberOfLines = 0;
    self.contentLab.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLab.text = @"1、介绍视频内容\n2、知道家长如何带领学习及视频意义";
    self.contentLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    [self addSubview:self.contentLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.height.equalTo(ME_HEIGHT_TABBAR);
    }];
    
    [self.tagScene makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, 0, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN));
        make.top.equalTo(self).offset(ME_LAYOUT_MARGIN * 2);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.left.equalTo(self.titleLab);
        make.right.equalTo(self);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitle.mas_bottom);
        make.left.equalTo(self.subTitle);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
        make.bottom.equalTo(self);
    }];
}

#pragma mark --- tagView DataSource & Delegate
/*
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.tags.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    NSString *tag = self.tags[index];
    UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    UIColor *bgColor = UIColorFromRGB(0xF5F5F5);
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = bgColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = tag;
    return label;
    
    MEBaseScene *scene = [[MEBaseScene alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    scene.backgroundColor = [UIColor pb_randomColor];
    return scene;
}

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    NSString *tag = self.tags[index];
    UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    CGSize tagSize = [tag pb_sizeThatFitsWithFont:font width:MESCREEN_WIDTH];
    return CGSizeMake(tagSize.width + ME_LAYOUT_MARGIN*2, ME_HEIGHT_STATUSBAR);
}
//*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
