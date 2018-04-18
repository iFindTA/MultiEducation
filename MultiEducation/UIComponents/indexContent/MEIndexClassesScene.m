//
//  MEIndexClassesScene.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexClassesScene.h"
#import "MEIndexContentScene.h"

@interface MEIndexClassesScene () <UIScrollViewDelegate>

@property (nonatomic, weak) MEIndexHeader *subNavigationBar;
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 内衬
 */
@property (nonatomic, strong) MEBaseScene *scrollLayout;

/**
 内容呈现content
 */
@property (nonatomic, strong) NSMutableArray <MEIndexContentScene *>*contentScenes;
@property (nonatomic, assign) NSUInteger lastSceneIndex;

@end

@implementation MEIndexClassesScene

+ (instancetype)classesSceneWithSubNavigationBar:(MEIndexHeader *)header {
    MEIndexClassesScene *scene = [[MEIndexClassesScene alloc] initWithFrame:CGRectZero subNavigationBar:header];
    return scene;
}

- (instancetype)initWithFrame:(CGRect)frame subNavigationBar:(MEIndexHeader *)header {
    self = [super initWithFrame:frame];
    if (self) {
        self.subNavigationBar = header;
        [self __initSubviews];
    }
    return self;
}

- (void)__initSubviews {
    
    self.lastSceneIndex = 0;
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.scrollLayout];
    
    NSArray <NSString *>*subTitles = [self.subNavigationBar fetchNavigationClasses];
    NSAssert(subTitles.count > 0, @"can not initialized classes scene with empty titles");
    NSUInteger subCounts = subTitles.count;
    //initialized sub contents
    NSUInteger width = MESCREEN_WIDTH;
    MEIndexContentScene *lastContent = nil;[self.contentScenes removeAllObjects];
    for (int i = 0; i < subCounts; i ++) {
        MEIndexContentScene *content = [[MEIndexContentScene alloc] initWithFrame:CGRectZero class:subTitles[i] typeCode:i];
        //content.backgroundColor = [UIColor pb_randomColor];
        [self.scrollLayout addSubview:content];
        [self.contentScenes addObject:content];
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollLayout);
            make.left.equalTo(self.scrollLayout).offset(MESCREEN_WIDTH * i);
            make.width.equalTo(width);
        }];
        weakify(self)
        content.callback = ^(BOOL hide){
            strongify(self)
            if (self.hideShowBarCallback) {
                self.hideShowBarCallback(hide);
            }
        };
        lastContent = content;
    }
    [self.scrollLayout makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastContent.mas_right);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.scrollLayout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

#pragma mark ---lazy getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        //_scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scrollView;
}

- (MEBaseScene *)scrollLayout {
    if (!_scrollLayout) {
        _scrollLayout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        //_scrollLayout.backgroundColor = [UIColor redColor];
        _scrollLayout.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scrollLayout;
}

- (NSMutableArray<MEIndexContentScene*> *)contentScenes {
    if (!_contentScenes) {
        _contentScenes = [NSMutableArray arrayWithCapacity:0];
    }
    return _contentScenes;
}

#pragma mark --- ScrollView Delegate

- (NSUInteger)currntPageIdx {
    float contentOffset_x = self.scrollView.contentOffset.x;
    CGFloat width = floorf(CGRectGetWidth(self.bounds));
    NSUInteger page = (contentOffset_x + (0.5f * width)) / width;
    return page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[self scrollViewDidTriggerScroll:scrollView];
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self scrollViewDidtrigger];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //[self scrollViewDidTriggerScroll:scrollView];
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self scrollViewDidtrigger];
    }
}

- (void)scrollViewDidTriggerScroll:(UIScrollView *)scroll {
    CGFloat progress  = 0;
    CGFloat currentOffsetX = scroll.contentOffset.x;
    CGFloat scrollViewW = scroll.bounds.size.width;
    // 1.计算progress
    progress = currentOffsetX / scrollViewW;
    // 3.将progress传递给header View
    [self.subNavigationBar scrollDidScrollProgress:progress];
}

- (void)scrollViewDidtrigger {
    NSUInteger curPage = [self currntPageIdx];
    [self.subNavigationBar scrollDidScroll2Page:curPage];
    if (curPage != self.lastSceneIndex) {
        self.lastSceneIndex = curPage;
        [self configureContentScene4Page:curPage];
    }
}

#pragma mark ---- 外部事件

- (void)displayDefaultClass {
    [self configureContentScene4Page:self.lastSceneIndex];
}

- (void)changeNavigationClass4Page:(NSUInteger)page {
    NSUInteger curPage = [self currntPageIdx];
    if (curPage == page) {
        return;
    }
    self.lastSceneIndex = page;
    //切换栏目
    CGPoint offset = CGPointMake(MESCREEN_WIDTH * page, 0);
    [self.scrollView setContentOffset:offset animated:false];
    //配置
    [self configureContentScene4Page:page];
}

/**
 配置内容scene
 */
- (void)configureContentScene4Page:(NSUInteger)page {
    //切换栏目 step1:调整搜索框的显示与隐藏
    [self.contentScenes[page] triggered2fixedSearchBarHideOrShowAction];
    //切换栏目 step2:预显示加载数据
    [self.contentScenes[page] viewWillAppear];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
