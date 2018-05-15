//
//  MEIndexBgScroller.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexLayouter.h"
#import "MEIndexBgScroller.h"

@interface MEIndexBgScroller () <UIScrollViewDelegate>

@property (nonatomic, weak) MEIndexNavigationBar *subBar;
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 内衬
 */
@property (nonatomic, strong) MEBaseScene *scrollLayout;

/**
 内容布局
 */
@property (nonatomic, strong) NSMutableArray <MEIndexLayouter *>*contentScenes;
@property (nonatomic, assign) NSUInteger lastSceneIndex;

@end

@implementation MEIndexBgScroller

+ (instancetype)sceneWithSubBar:(MEIndexNavigationBar *)bar {
    MEIndexBgScroller *scene = [[MEIndexBgScroller alloc] initWithFrame:CGRectZero subBar:bar];
    return scene;
}

- (instancetype)initWithFrame:(CGRect)frame subBar:(MEIndexNavigationBar *)bar {
    self = [super initWithFrame:frame];
    if (self) {
        self.subBar = bar;
        [self __initSubviews];
    }
    return self;
}

- (void)__initSubviews {
    
    self.lastSceneIndex = 0;
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.scrollLayout];
    
    NSArray <NSString *>*subCodes = self.subBar.indexBarCodes;
    NSAssert(subCodes.count > 0, @"can not initialized classes scene with empty titles");
    NSUInteger subCounts = subCodes.count;
    //initialized sub contents
    NSUInteger width = MESCREEN_WIDTH;
    MEIndexLayouter *lastContent = nil;[self.contentScenes removeAllObjects];
    for (int i = 0; i < subCounts; i++) {
        NSString *code = subCodes[i];
        MEIndexLayouter *content = [[MEIndexLayouter alloc] initWithFrame:CGRectZero reqCode:code];
        //content.backgroundColor = [UIColor pb_randomColor];
        [self.scrollLayout addSubview:content];
        [self.contentScenes addObject:content];
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollLayout);
            make.left.equalTo(self.scrollLayout).offset(MESCREEN_WIDTH * i);
            make.width.equalTo(width);
        }];
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

- (NSMutableArray<MEIndexLayouter*> *)contentScenes {
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

//- (void)scrollViewDidTriggerScroll:(UIScrollView *)scroll {
//    CGFloat progress  = 0;
//    CGFloat currentOffsetX = scroll.contentOffset.x;
//    CGFloat scrollViewW = scroll.bounds.size.width;
//    // 1.计算progress
//    progress = currentOffsetX / scrollViewW;
//    // 3.将progress传递给header View
//    [self.subNavigationBar scrollDidScrollProgress:progress];
//}

- (void)scrollViewDidtrigger {
    NSUInteger curPage = [self currntPageIdx];
    [self.subBar scrollDidScroll2Page:curPage];
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
    //[self.contentScenes[page] triggered2fixedSearchBarHideOrShowAction];
    //切换栏目 step2:预显示加载数据
    [self.contentScenes[page] indexLayoutViewWillAppear];
}

@end
