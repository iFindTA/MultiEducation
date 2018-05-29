//
//  MEPlayInfoSubTitlePanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayInfoSubTitlePanel.h"

@interface MEPlayInfoSubTitlePanel ()

@property (nonatomic, copy) NSString *infoDesc;

@property (nonatomic, strong) MEBaseLabel *subTitle;
@property (nonatomic, strong) MEBaseLabel *contentLab;
//@property (nonatomic, strong) UIWebView *contentLab;

@end

@implementation MEPlayInfoSubTitlePanel

+ (CGFloat)estimateVideoDescriptionPanelHeight4Description:(NSString *)desc {
    CGFloat height = ME_LAYOUT_ICON_HEIGHT;
    CGFloat descWidth = MESCREEN_WIDTH - ME_LAYOUT_MARGIN*4;
    //UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    //CGSize descSize = [desc pb_sizeThatFitsWithFont:font width:descWidth];
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [desc dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    CGSize descSize = [attr boundingRectWithSize:CGSizeMake(descWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return height + descSize.height + ME_LAYOUT_BOUNDARY;
}

+ (instancetype)configreInfoSubTitleDescriptionPanelWithInfo:(NSString *)desc {
    CGFloat estimateHeight = [self estimateVideoDescriptionPanelHeight4Description:desc];
    CGRect estimateBounds = (CGRect){.origin = CGPointZero, .size = CGSizeMake(MESCREEN_WIDTH, estimateHeight)};
    MEPlayInfoSubTitlePanel *panel = [[MEPlayInfoSubTitlePanel alloc] initWithFrame:estimateBounds withDescription:desc];
    return panel;
}

- (instancetype)initWithFrame:(CGRect)frame withDescription:(NSString *)info {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.infoDesc = info.copy;
        [self __initVideoPlayDescriptionSubview];
    }
    return self;
}

- (void)__initVideoPlayDescriptionSubview {
    
    //对爸爸妈妈说的话
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_TITLE-1);
    self.subTitle = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    //self.subTitle.backgroundColor = [UIColor greenColor];
    self.subTitle.font = font;
    self.subTitle.text = @"对爸爸妈妈说的话：";//此处建议动态获取
    self.subTitle.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    [self addSubview:self.subTitle];
    font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
    //*
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.infoDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.contentLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    //self.contentLab.backgroundColor = [UIColor blueColor];
    //self.contentLab.text = self.infoDesc;
    //self.contentLab.font = font;
    self.contentLab.numberOfLines = 0;
    self.contentLab.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLab.attributedText = attrStr;
    //self.contentLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    [self addSubview:self.contentLab];
    //*/
    //self.contentLab = [[UIWebView alloc] initWithFrame:CGRectZero];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN*2);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitle.mas_bottom);
        make.left.equalTo(self.subTitle);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
        make.bottom.equalTo(self);
    }];
}

@end
