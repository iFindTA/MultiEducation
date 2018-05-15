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

@interface MEIndexLayouter () <UIScrollViewDelegate, YJBannerViewDelegate, YJBannerViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) int32_t indexCode;

@property (nonatomic, strong) MEPBIndexItem *dataItem;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

@property (nonatomic, strong) YJBannerView *banner;

@end

@implementation MEIndexLayouter

- (id)initWithFrame:(CGRect)frame reqCode:(int32_t)code {
    self = [super initWithFrame:frame];
    if (self) {
        _indexCode = code;
        
        [self addSubview:self.scroller];
        
        [self.scroller addSubview:self.layout];
        weakify(self)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongify(self)
            [self reloadIndexItemData];
        }];
        [header setTitle:@"使劲往下拽..." forState:MJRefreshStateIdle];
        [header setTitle:@"等待也是一种享受" forState:MJRefreshStateRefreshing];
        [header setTitle:@"放手是一种态度..." forState:MJRefreshStatePulling];
        self.scroller.mj_header = header;
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
        //_layout.backgroundColor = [UIColor redColor];
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
    UIImage *image = [UIImage pb_iconFont:nil withName:ME_ICONFONT_EMPTY_HOLDER withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_TITLE;
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_DESC;
    if ([[PBService shared] netState] == PBNetStateUnavaliable) {
        text = ME_EMPTY_PROMPT_NETWORK;
    }
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSC(METHEME_FONT_SUBTITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return adoptValue(ME_EMPTY_PROMPT_OFFSET);
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
/*
- (NSArray*)bannerViewTitles:(YJBannerView *)bannerView {
    NSArray <MEPBRes *>*items = self.dataItem.topListArray;
    __block NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
    [items enumerateObjectsUsingBlock:^(MEPBRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:obj.title.copy];
    }];
    return urls.copy;
}//*/

- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSArray <MEPBRes *>*items = self.dataItem.topListArray;
    MEPBRes *video = [items objectAtIndex:index];
    NSDictionary *params = @{@"id":@(video.resId), @"url":PBAvailableString(video.filePath)};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEVideoPlayProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [MEKits handleError:err];
}

#pragma mark --- Data Load & Storage relevant

#define ME_INDEX_TAB_CACHE_PATH             @"cache/index"

- (NSString *)storageFileName {
    return PBFormat(@"indexLayout_%d.bat", self.indexCode);
}

- (NSData *_Nullable)fetchIndexCacheLocalStorage {
    NSString *rootPath = [MEKits sandboxPath];
    NSString *fileName = [self storageFileName];
    NSString *dir = [rootPath stringByAppendingPathComponent:ME_INDEX_TAB_CACHE_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [dir stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    return nil;
}

- (BOOL)saveIndexCacheData2LocalStorage:(NSData *)data {
    if (!data) {
        NSLog(@"got an empty data!");
        return false;
    }
    NSString *rootPath = [MEKits sandboxPath];
    NSString *dir = [rootPath stringByAppendingPathComponent:ME_INDEX_TAB_CACHE_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *fileName = [self storageFileName];
    NSString *filePath = [dir stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    return [data writeToFile:filePath atomically:true];
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
    NSData *localData = [self fetchIndexCacheLocalStorage];
    if (localData != nil) {
        NSError *err;
        MEPBIndexItem *item = [MEPBIndexItem parseFromData:localData error:&err];
        if (item && !err) {
            self.dataItem = item;
            [self rebuildIndexLayoutUI];
            return;
        }
        //[MEKits handleError:err];
    }
    
    [self.scroller.mj_header beginRefreshing];
}

- (void)reloadIndexItemData {
    //[self showIndecator];
    MEPBIndexClass *indexTab = [[MEPBIndexClass alloc] init];
    indexTab.index = self.indexCode;
    MEIndexVM *vm = [[MEIndexVM alloc] init];
    weakify(self)
    [vm postData:[indexTab data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBIndexClass *classes = [MEPBIndexClass parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            [self displayErrorWhhileDataEmpty];
        } else {
            MEPBIndexItem *item = classes.catsArray[self.indexCode];
            self.dataItem = item;
            [self rebuildIndexLayoutUI];
            //save to local storage
            NSData *binary = [item data];
            [self saveIndexCacheData2LocalStorage:binary];
        }
        //[self hiddenIndecator];
        [self.scroller.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [MEKits handleError:error];
        //[self hiddenIndecator];
        [self.scroller.mj_header endRefreshing];
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
    CGFloat bannerHeight = adoptValue(140);
    CGRect bounds = CGRectMake(ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, MESCREEN_WIDTH - ME_LAYOUT_MARGIN * 2, bannerHeight);
    UIImage *img = [UIImage imageNamed:@"index_content_placeholder"];
    self.banner = [YJBannerView bannerViewWithFrame:bounds dataSource:self delegate:self emptyImage:img placeholderImage:img selectorString:@"sd_setImageWithURL:placeholderImage:"];
    self.banner.pageControlStyle = PageControlHollow;
    self.banner.pageControlAliment = PageControlAlimentRight;
    self.banner.pageControlHighlightColor = UIColorFromRGB(0xCCCCCC);
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
    //subClasses.backgroundColor = [UIColor pb_randomColor];
    [self.layout addSubview:subClasses];
    [subClasses makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banner.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.equalTo(self.layout);
        make.right.equalTo(self.layout);
        make.height.equalTo(subClassHeight);
    }];
    weakify(self)
    subClasses.subClassesCallback = ^(NSUInteger tag){
        strongify(self)
        [self indexLayoutStoryClassDidTouchEvent:tag];
    };
    
    //*推荐视频小分类
    NSArray <MEPBResType*>*recommand = self.dataItem.recommendTypeListArray.copy;
    //NSLog(@"recommand:%@", recommand);
    __block MEBaseScene *lastSection = nil;__block MEBaseScene *lastItem = nil;
    NSUInteger sectionHeight = ME_LAYOUT_ICON_HEIGHT;
    UIFont *sectFont = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    UIFont *itemFont = UIFontPingFangSCBold(METHEME_FONT_SUBTITLE);
    UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    //prepare for item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    NSUInteger itemMargin = ME_LAYOUT_MARGIN;NSUInteger itemDistance = ME_LAYOUT_MARGIN;
    NSUInteger itemWidth = (MESCREEN_WIDTH-itemMargin*2-itemDistance*(numPerLine-1))/numPerLine;NSUInteger itemHeight = adoptValue(ME_INDEX_STORY_ITEM_HEIGHT);
    for (int i = 0;i < recommand.count;i++) {
        MEPBResType *type = recommand[i];
        MEBaseScene *sectTitleScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        //sectTitleScene.backgroundColor = [UIColor pb_randomColor];
        [self.layout addSubview:sectTitleScene];
        [sectTitleScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastItem == nil)?subClasses.mas_bottom:lastItem.mas_bottom);
            make.left.right.equalTo(self.layout);
            make.height.equalTo(sectionHeight);
        }];
        MEBaseLabel *sectTitleLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        sectTitleLab.font = sectFont;
        sectTitleLab.textColor = fontColor;
        sectTitleLab.text = type.title;
        [sectTitleScene addSubview:sectTitleLab];
        [sectTitleLab makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(sectTitleScene).insets(UIEdgeInsetsMake(0, ME_LAYOUT_MARGIN, 0, ME_LAYOUT_MARGIN));
        }];
        lastSection = sectTitleScene;
        //items
        NSArray <MEPBRes*>*courseItems = [type resPbArray].copy;
        //NSLog(@"section:%@-----item counts:%d", type.title, courseItems.count);
        
        for (int j = 0;j < courseItems.count;j++) {
            MEPBRes *item = courseItems[j];
            NSUInteger __row_idx = j / numPerLine;NSUInteger __col_idx = j % numPerLine;
            NSUInteger offset_x = itemMargin + (itemWidth+itemDistance)*__col_idx;
            NSUInteger offset_y = itemMargin + itemHeight*__row_idx;
            //NSLog(@"row:%d-------col:%d-=====offset_x:%zd======offset_y:%zd", __row_idx, __col_idx, offset_x, offset_y);
            MEBaseScene *itemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
            itemScene.sectionTag = i;itemScene.tag = j;
            //itemScene.backgroundColor = [UIColor pb_randomColor];
            [self.layout addSubview:itemScene];
            [itemScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastSection.mas_bottom).offset(offset_y);
                make.left.equalTo(self.layout).offset(offset_x);
                make.size.equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            //*
             MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
             label.font = itemFont;
             label.textColor = fontColor;
             label.text = item.title.copy;
             [itemScene addSubview:label];
             [label makeConstraints:^(MASConstraintMaker *make) {
                 make.left.bottom.right.equalTo(itemScene);
                 make.height.equalTo(adoptValue(ME_LAYOUT_ICON_HEIGHT));
             }];
             NSString *url = [MEKits imageFullPath:item.coverImg];
             MEBaseImageView *image = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
             image.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
            image.layer.masksToBounds = true;
             [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
             [itemScene addSubview:image];
             [image makeConstraints:^(MASConstraintMaker *make) {
                 make.top.left.right.equalTo(itemScene);
                 make.bottom.equalTo(label.mas_top);
             }];//*/
            //add gesture
            UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexLayoutStoryItemDidTouchEvent:)];
            tapGestuer.numberOfTapsRequired = 1;
            tapGestuer.numberOfTouchesRequired = 1;
            [itemScene addGestureRecognizer:tapGestuer];
            lastItem = itemScene;
        }
    }
    
    //adjust scroll layout
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo((lastItem==nil)?lastSection.mas_bottom:lastItem.mas_bottom);
    }];
    //*/
}

- (void)indexLayoutStoryItemDidTouchEvent:(UITapGestureRecognizer *)tap {
    MEBaseScene *tapView = (MEBaseScene *)[tap view];
    NSUInteger sectionTag = tapView.sectionTag;NSUInteger rowTag = tapView.tag;
    NSArray <MEPBResType*>*recommand = self.dataItem.recommendTypeListArray.copy;
    if (sectionTag >= recommand.count) {
        return;
    }
    MEPBResType *type = recommand[sectionTag];
    NSArray <MEPBRes*>*items = type.resPbArray.copy;
    if (rowTag >= items.count) {
        return;
    }
    MEPBRes *item = items[rowTag];
    NSNumber *vid = @(item.resId);NSNumber *resType = @(item.type);
    NSString *title = PBAvailableString(item.title); NSString *coverImg = PBAvailableString(item.coverImg);
    NSDictionary *params = @{@"vid":vid, @"type":resType, @"title":title, @"coverImg":coverImg};
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
}

- (void)indexLayoutStoryClassDidTouchEvent:(NSUInteger)tag {
    NSArray <MEPBResType*>*classes = self.dataItem.resTypeListArray.copy;
    MEPBResType *type = classes[tag];
    //班级 根据小班/中班/大班 区分不同资源
    NSInteger gradeId = self.indexCode == 0 ? 0 : (self.indexCode + 2);
    NSDictionary *params = @{@"typeId":@(type.id_p), @"title":PBAvailableString(type.title), @"gradeId":@(gradeId)};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MESubClassProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [MEKits handleError:err];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
