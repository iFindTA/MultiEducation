//
//  MEPlayerInfoScene.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayerInfoScene.h"

@interface MEPlayerInfoScene ()

@property (nonatomic, strong) NSDictionary *descInfo;

@property (nonatomic, strong) MEBaseLabel *titleLab;

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
        self.backgroundColor = [UIColor pb_randomColor];
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
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.height.equalTo(ME_HEIGHT_TABBAR);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
