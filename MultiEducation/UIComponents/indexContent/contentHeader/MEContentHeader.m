//
//  MEContentHeader.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEContentHeader.h"
#import "MEContentSubcategory.h"
#import <YJBannerView/YJBannerView.h>

//banner height
static NSUInteger const ME_CONTENT_HEADER_BANNER_HEIGHT                             =   100;
//ad height
static NSUInteger const ME_CONTENT_HEADER_AD_HEIGHT                                 =   30;

@interface MEContentHeader () <YJBannerViewDelegate, YJBannerViewDataSource>

/**
 头部信息集合
 */
@property (nonatomic, strong) NSDictionary *mapInfo;

@property (nonatomic, strong) YJBannerView *banner;

/**
 头部控件高度
 */
@property (nonatomic, assign) CGFloat headerHeight;

@end

static CGFloat ME_SUBCLASS_PANEL_HEIGHT;

@implementation MEContentHeader

+ (CGFloat)estimateHeaderHeight4MapInfo:(NSDictionary *)map {
    if (!map) {
        return 0;
    }
    //banner
    CGFloat header_height = ME_LAYOUT_BOUNDARY+ME_CONTENT_HEADER_BANNER_HEIGHT;
    //子分类
    NSArray *subItems = [map objectForKey:@"subClasses"];
    subItems = @[@"1",@"2",@"3",@"4",@"5"];
    ME_SUBCLASS_PANEL_HEIGHT = [MEContentSubcategory subcategoryClassPanelHeight4Classes:subItems] + ME_LAYOUT_BOUNDARY;
    header_height += ME_SUBCLASS_PANEL_HEIGHT;
    //广告ad
    //BOOL whetherShowAD = false;
    
    return header_height;
}

+ (instancetype)headerWithLayoutInfo:(NSDictionary *)info {
    CGFloat headerHeight = [self estimateHeaderHeight4MapInfo:info];
    MEContentHeader *header = [[MEContentHeader alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, headerHeight) layoutInfo:info];
    return header;
}

- (id)initWithFrame:(CGRect)frame layoutInfo:(NSDictionary *)info {
    self = [super initWithFrame:frame];
    if (self) {
        self.mapInfo = info.copy;
        [self __initContentHeaderSubviews];
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)__initContentHeaderSubviews {
    //banner
    CGRect bounds = CGRectMake(ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, MESCREEN_WIDTH - ME_LAYOUT_MARGIN * 2, ME_CONTENT_HEADER_BANNER_HEIGHT);
    UIImage *img = [UIImage imageNamed:@"index_content_header_placeholder"];
    self.banner = [YJBannerView bannerViewWithFrame:bounds dataSource:self delegate:self emptyImage:img placeholderImage:img selectorString:@"sd_setImageWithURL:placeholderImage:"];
    self.banner.pageControlStyle = PageControlHollow;
    self.banner.pageControlAliment = PageControlAlimentRight;
    [self addSubview:self.banner];
    [self.banner reloadData];
    
    //推荐分类 height = 40
    NSArray *items =@[@{@"title":@"视频故事", @"img":@"http://dl.hiapphere.com/data/icon/201705/HiAppHere_com_com.leomaz.flix.png"},
                      @{@"title":@"歌曲欣赏", @"img":@"http://icons.iconarchive.com/icons/graphicloads/100-flat/256/home-icon.png"},
                      @{@"title":@"科学探索", @"img":@"http://icons.iconarchive.com/icons/graphicloads/100-flat/256/home-icon.png"},
                      @{@"title":@"艺术天地", @"img":@"http://icons.iconarchive.com/icons/graphicloads/100-flat/256/home-icon.png"},
                      @{@"title":@"周末大餐", @"img":@"http://icons.iconarchive.com/icons/graphicloads/100-flat/256/home-icon.png"}];
    MEContentSubcategory *subClass = [MEContentSubcategory subcategoryWithClasses:items];
    [self addSubview:subClass];
    weakify(self)
    subClass.subClassesCallback = ^(NSUInteger tag){
        strongify(self)
        [self subCategoryClassTouchIndex:tag];
    };
    [subClass makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banner.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(ME_SUBCLASS_PANEL_HEIGHT);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.banner makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN));
//    }];
}

#pragma mark --- Banner DataSource & Delegate
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView {
    //NSArray *list = [self.mapInfo objectForKey:@"banner"];
    return @[@"http://www.storyonline.com.tw/upload/banner-3dc1d1ef4d29339ad3f1315438e95132.jpg",
             @"https://www.telegraph.co.uk/content/dam/pensions-retirement/2017/09/05/TELEMMGLPICT000099642623_trans_NvBQzQNjv4BqpVlberWd9EgFPZtcLiMQfyf2A9a6I9YchsjMeADBa08.jpeg?imwidth=450",
             @"https://www.hkpl.gov.hk/tc/common/images/extension-activities/event-detail/story_a.jpg",
             @"http://www.bvgv.com/uploadfile/2016/0823/20160823094515262.jpg"];
}

- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *params = @{@"title":@"多元幼教AD", @"url":@"http://baidu.com/"};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEBabyWebProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
}

#pragma mark --- Touch Event

- (void)subCategoryClassTouchIndex:(NSUInteger)index {
    NSDictionary *params = @{@"title":@"歌曲欣赏", @"url":@"http://baidu.com/"};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEIndexSubClassProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
