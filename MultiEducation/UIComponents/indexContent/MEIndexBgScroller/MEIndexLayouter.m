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

@property (nonatomic, assign) NSUInteger indexCode;

@property (nonatomic, strong) MEPBIndexItem *dataItem;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

@property (nonatomic, strong) YJBannerView *banner;

@end

@implementation MEIndexLayouter

- (id)initWithFrame:(CGRect)frame reqCode:(NSUInteger)code {
    self = [super initWithFrame:frame];
    if (self) {
        _indexCode = code;
        
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
    
    [self loadLocalStorage];
}

#pragma mark ---lazy getter

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scroller.backgroundColor = [UIColor whiteColor];
        _scroller.delegate = self;
        _scroller.emptyDataSetSource = self;
        _scroller.emptyDataSetDelegate = self;
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

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataItem == nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *imgColor =UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *image = [UIImage pb_iconFont:nil withName:@"\U0000e673" withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀！";
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"服务器貌似在偷懒，您稍等我去揍它...";
    if ([[PBService shared] netState] == PBNetStateUnavaliable) {
        text = @"您貌似断开了互联网链接，请检查网络稍后重试！";
    }
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSC(METHEME_FONT_SUBTITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return true;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self reloadIndexItemData];
}

#pragma mark --- Banner DataSource & Delegate
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView {
    //NSArray *list = [self.mapInfo objectForKey:@"banner"];
    NSArray <MEPBRes *>*items = self.dataItem.topListArray;
    __block NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
    [items enumerateObjectsUsingBlock:^(MEPBRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [MEKits imageFullPath:obj.coverImg];
        [urls addObject:url];
    }];
    return urls.copy;
}

- (NSArray*)bannerViewTitles:(YJBannerView *)bannerView {
    NSArray <MEPBRes *>*items = self.dataItem.topListArray;
    __block NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
    [items enumerateObjectsUsingBlock:^(MEPBRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:obj.title.copy];
    }];
    return urls.copy;
}

- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSArray <MEPBRes *>*items = self.dataItem.topListArray;
    MEPBRes *video = [items objectAtIndex:index];
    NSDictionary *params = @{@"id":@(video.resId), @"url":video.URL};
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
     *  1.3 加载线上资源
     */
    
    [self reloadIndexItemData];
}

- (void)reloadIndexItemData {
    [self showIndecator];
    MEPBIndexClass *indexTab = [[MEPBIndexClass alloc] init];
    indexTab.index = self.indexCode;
    MEIndexVM *vm = [[MEIndexVM alloc] init];
    weakify(self)
    [vm postData:[indexTab data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBIndexClass *classes = [MEPBIndexClass parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
            [self displayErrorWhhileDataEmpty];
        } else {
            self.dataItem = classes.catsArray[self.indexCode];
            [self rebuildIndexLayoutUI];
        }
        [self hiddenIndecator];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
        [self hiddenIndecator];
        [self displayErrorWhhileDataEmpty];
    }];
}

- (void)displayErrorWhhileDataEmpty {
    [self.scroller reloadEmptyDataSet];
}

/**
 rebuild ui
 */
- (void)rebuildIndexLayoutUI {
    [self.scroller reloadEmptyDataSet];
    //remove old items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.dataItem) {
        return;
    }
    
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
    NSArray <MEPBResType*>*classes = self.dataItem.resTypeListArray.copy;
    NSMutableArray *cats = [NSMutableArray arrayWithCapacity:0];
    [classes enumerateObjectsUsingBlock:^(MEPBResType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *item = @{@"title":obj.title, @"img":[MEKits imageFullPath:obj.iconPath]};
        [cats addObject:item];
    }];
    CGFloat subClassHeight = [MEContentSubcategory subcategoryClassPanelHeight4Classes:classes];
    MEContentSubcategory *subClasses = [MEContentSubcategory subcategoryWithClasses:cats.copy];
    subClasses.backgroundColor = [UIColor pb_randomColor];
    [self.layout addSubview:subClasses];
    [subClasses makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banner.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(self.layout).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self.layout).offset(-ME_LAYOUT_MARGIN);
        make.height.equalTo(subClassHeight);
    }];
    weakify(self)
    subClasses.subClassesCallback = ^(NSUInteger tag){
        strongify(self)
        [self indexLayoutStoryClassDidTouchEvent:tag];
    };
    
    //推荐视频小分类
    NSArray <MEPBResType*>*recommand = self.dataItem.resTypeListArray;
    NSLog(@"recommand:%@", recommand);
    __block MEBaseScene *lastSection = nil;__block MEBaseScene *lastItem = nil;
    NSUInteger sectionHeight = ME_LAYOUT_ICON_HEIGHT;
    UIFont *sectFont = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    UIFont *itemFont = UIFontPingFangSCBold(METHEME_FONT_SUBTITLE);
    UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    //prepare for item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    NSUInteger itemMargin = ME_LAYOUT_MARGIN;NSUInteger itemDistance = ME_LAYOUT_MARGIN * 2;
    NSUInteger itemWidth = (MESCREEN_WIDTH-itemMargin*2-itemDistance*(numPerLine-1))/numPerLine;NSUInteger itemHeight = adoptValue(ME_INDEX_STORY_ITEM_HEIGHT);
    [recommand enumerateObjectsUsingBlock:^(MEPBResType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MEBaseScene *sectTitleScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        sectTitleScene.backgroundColor = [UIColor pb_randomColor];
        [self.layout addSubview:sectTitleScene];
        lastSection = sectTitleScene;
        [sectTitleScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastItem == nil)?subClasses.mas_bottom:lastItem.mas_bottom).offset(ME_LAYOUT_MARGIN);
            make.left.right.equalTo(self.layout);
            make.height.equalTo(sectionHeight);
        }];
        MEBaseLabel *sectTitleLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        sectTitleLab.font = sectFont;
        sectTitleLab.textColor = fontColor;
        sectTitleLab.text = obj.title;
        [sectTitleScene addSubview:sectTitleLab];
        [sectTitleLab makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(sectTitleScene).insets(UIEdgeInsetsMake(0, ME_LAYOUT_MARGIN, 0, ME_LAYOUT_MARGIN));
        }];
        //items
        NSArray <MEPBRes*>*courseItems = [obj resPbArray].copy;
        [courseItems enumerateObjectsUsingBlock:^(MEPBRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger __row_idx = idx % numPerLine;NSUInteger __col_idx = idx / numPerLine;
            NSUInteger offset_x = itemMargin + (itemWidth+itemDistance)*__col_idx;
            NSUInteger offset_y = itemMargin + (itemHeight+ME_LAYOUT_MARGIN)*__row_idx;
            MEBaseScene *itemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
            itemScene.backgroundColor = [UIColor pb_randomColor];
            [self.layout addSubview:itemScene];
            [itemScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastSection.mas_bottom).offset(offset_x);
                make.left.equalTo(self.layout).offset(offset_y);
                make.size.equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            label.font = itemFont;
            label.textColor = fontColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = obj.title.copy;
            [itemScene addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(itemScene);
                make.height.equalTo(adoptValue(ME_LAYOUT_ICON_HEIGHT));
            }];
            NSString *url = [MEKits imageFullPath:obj.coverImg];
            MEBaseImageView *image = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            [itemScene addSubview:image];
            [image makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(itemScene);
                make.bottom.equalTo(label.mas_top);
            }];
            //add gesture
            UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexLayoutStoryItemDidTouchEvent:)];
            tapGestuer.numberOfTapsRequired = 1;
            tapGestuer.numberOfTouchesRequired = 1;
            [itemScene addGestureRecognizer:tapGestuer];
            lastItem = itemScene;
        }];
    }];
    
    //adjust scroll layout
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo((lastItem==nil)?lastSection.mas_bottom:lastItem.mas_bottom).offset(-ME_LAYOUT_MARGIN);
    }];
}

- (void)indexLayoutStoryItemDidTouchEvent:(MEBaseScene *)scene {
    NSDictionary *params = @{@"title":@"蚂蚁先生搬家", @"desc":@"这是对爸爸妈妈说的话，要记牢！"};
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [self handleTransitionError:err];
}

- (void)indexLayoutStoryClassDidTouchEvent:(NSUInteger)tag {
    NSArray <MEPBResType*>*classes = self.dataItem.resTypeListArray.copy;
    MEPBResType *type = classes[tag];
    NSDictionary *params = @{@"id":@(type.id_p), @"title":type.title};
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
