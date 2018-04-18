//
//  MEIndexLayouter.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexVM.h"
#import "MEIndexLayouter.h"
#import <MJRefresh/MJRefresh.h>
#import "MEContentSubcategory.h"
#import <YJBannerView/YJBannerView.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

//banner height
static NSUInteger const ME_CONTENT_HEADER_BANNER_HEIGHT                             =   100;

@interface MEIndexLayouter () <UIScrollViewDelegate, YJBannerViewDelegate, YJBannerViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NSUInteger msgCode;

@property (nonatomic, strong) MEPBIndexItem *dataItem;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

@property (nonatomic, strong) YJBannerView *banner;

@end

@implementation MEIndexLayouter

- (id)initWithFrame:(CGRect)frame reqCode:(NSUInteger)code {
    self = [super initWithFrame:frame];
    if (self) {
        _msgCode = code;
        
        [self addSubview:self.scroller];
        
        [self.scroller addSubview:self.layout];
        weakify(self)
        self.scroller.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongify(self)
            [self reloadIndexItemData];
        }];
    }
    return self;
}

- (void)indexLayoutViewWillAppear {
    if (self.dataItem != nil) {
        return;
    }
    [self showIndecator];
    [self loadLocalStorage];
}

#pragma mark ---lazy getter

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scroller.backgroundColor = [UIColor blueColor];
        _scroller.delegate = self;
        _scroller.pagingEnabled = false;
        _scroller.showsVerticalScrollIndicator = true;
        _scroller.showsHorizontalScrollIndicator = false;
        _scroller.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scroller;
}

- (MEBaseScene *)layout {
    if (!_layout) {
        _layout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _layout.backgroundColor = [UIColor redColor];
        _layout.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _layout;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scroller makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.width.equalTo(self.scroller);
    }];
}

#pragma mark --- DZNEmpty DataSource & Deleagte

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    
//}
//
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    
//}
//
//- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
//    
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    
//}

#pragma mark --- Banner DataSource & Delegate
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView {
    //NSArray *list = [self.mapInfo objectForKey:@"banner"];
    NSArray <MEPBCourseVideo *>*items = self.dataItem.topListArray;
    __block NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
    NSString *host = self.currentUser.bucketDomain;
    [items enumerateObjectsUsingBlock:^(MEPBCourseVideo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", host, obj.coverImg];
        [urls addObject:url];
    }];
    return urls.copy;
}

- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSArray <MEPBCourseVideo *>*items = self.dataItem.topListArray;
    MEPBCourseVideo *video = [items objectAtIndex:index];
    NSDictionary *params = @{@"id":@(video.id_p), @"url":video.videoPath};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEVideoPlayProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
}

/**
 app首次启动首先加载本地缓存
 */
- (void)loadLocalStorage {
    /**
     *  step1 查询数据库
     *  1.1 数据库如果有则显示缓存并刷新
     *  1.2 数据库如果没有就显示bundle打包资源并刷新
     */
    
    MEIndexVM *vm = [[MEIndexVM alloc] init];
    vm.msg = PBFormat(@"%d", self.msgCode);
    weakify(self)
    [vm postData:[NSData data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBIndexClass *classes = [MEPBIndexClass parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
        } else {
            self.dataItem = classes.catsArray[self.msgCode];
            [self rebuildIndexLayoutUI];
        }
        [self hiddenIndecator];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
        [self hiddenIndecator];
    }];
}

- (void)reloadIndexItemData {
    
}

/**
 rebuild ui
 */
- (void)rebuildIndexLayoutUI {
    //remove old items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //banner
    CGFloat bannerHeight = adoptValue(ME_CONTENT_HEADER_BANNER_HEIGHT);
    CGRect bounds = CGRectMake(ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, MESCREEN_WIDTH - ME_LAYOUT_MARGIN * 2, bannerHeight);
    UIImage *img = [UIImage imageNamed:@"index_content_header_placeholder"];
    self.banner = [YJBannerView bannerViewWithFrame:bounds dataSource:self delegate:self emptyImage:img placeholderImage:img selectorString:@"sd_setImageWithURL:placeholderImage:"];
    self.banner.pageControlStyle = PageControlHollow;
    self.banner.pageControlAliment = PageControlAlimentRight;
    [self.layout addSubview:self.banner];
    [self.banner makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.layout).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self.layout).offset(-ME_LAYOUT_MARGIN);
        make.height.equalTo(bannerHeight);
    }];
    [self.banner reloadData];
    
    //子分类
    NSArray <MEPBCourseVideoClass*>*classes = self.dataItem.courseVideoCatPbArray;
    NSMutableArray *cats = [NSMutableArray arrayWithCapacity:0];
    [classes enumerateObjectsUsingBlock:^(MEPBCourseVideoClass * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *item = @{@"title":obj.catName, @"img":obj.iconPath};
        [cats addObject:item];
    }];
    CGFloat subClassHeight = [MEContentSubcategory subcategoryClassPanelHeight4Classes:classes];
    MEContentSubcategory *subClasses = [MEContentSubcategory subcategoryWithClasses:cats.copy];
    [self.layout addSubview:subClasses];
    [subClasses makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banner.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(self.layout).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self.layout).offset(-ME_LAYOUT_MARGIN);
        make.height.equalTo(subClassHeight);
    }];
    
    //推荐视频小分类
    NSArray <MEPBCourseVideoClass*>*recommand = self.dataItem.recommendCatArray;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
