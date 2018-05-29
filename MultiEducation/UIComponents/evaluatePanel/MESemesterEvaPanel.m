//
//  MESemesterEvaPanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/29.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESemesterEvaPanel.h"
#import "MESubNavigator.h"

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价问题item

@interface MESEQuestionItem: MEBaseScene

@end

@implementation MESEQuestionItem

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价Panel

@interface MESEQuestionPanel: MEBaseScene

/**
 数据源
 */
@property (nonatomic, strong) SEEvaluateType *source;

@property (nonatomic, strong) MEBaseScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

+ (instancetype)panelWithSource:(SEEvaluateType*)type;

@end

@implementation MESEQuestionPanel

+(instancetype)panelWithSource:(SEEvaluateType *)type {
    return [[MESEQuestionPanel alloc] initWithFrame:CGRectZero source:type];
}

- (id)initWithFrame:(CGRect)frame source:(SEEvaluateType *)type {
    self = [super initWithFrame:frame];
    if (self) {
        _source = type;
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    [self addSubview:self.scroller];
    [self.scroller addSubview:self.layout];
    [self.scroller makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.width.equalTo(self.scroller);
    }];
    //sub types
    NSArray<SEEvaluateSubType*>*subTypes = self.source.subTypesArray.copy;
    MEBaseScene *lastSection;MESEQuestionItem *lastItem;
    for (SEEvaluateSubType *sub in subTypes) {
        //分区
        
        
        NSArray<SEEvaluateItem *>*items = sub.itemsArray.copy;
        for (SEEvaluateItem *item in items) {
            
        }
    }
}

#pragma mark --- lazy loading

- (MEBaseScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[MEBaseScrollView alloc] initWithFrame:CGRectZero];
        _scroller.bounces = true;
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
    }
    return _layout;
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价整体Panel

@interface MESemesterEvaPanel ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *fatherView;

/**
 当前学生ID
 */
@property (nonatomic, assign) int64_t currentSID;

/**
 获取到的元数据
 */
@property (nonatomic, strong) SemesterEvaluate *originSource;

/**
 当前分类
 */
@property (nonatomic, assign) NSUInteger currentSubClassIndex;
@property (nonatomic, strong) MESubNavigator *subNavigator;

/**
 所有问题列表
 */
@property (nonatomic, strong) NSMutableArray<MESEQuestionPanel*>*quesPanels;
@property (nonatomic, strong) MEBaseScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

@end

@implementation MESemesterEvaPanel

- (id)initWithFrame:(CGRect)frame father:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        _fatherView = view;
        self.backgroundColor = [UIColor pb_randomColor];
    }
    return self;
}

- (void)exchangedStudent2Evaluate:(SemesterEvaluate *)semester {
    if (semester.studentId == self.currentSID) {
        return;
    }
    //step1 切换学生 先暂存
    
    //step2 获取新数据
    self.originSource = semester;
    weakify(self)
    MESEInfoVM *vm = [[MESEInfoVM alloc] init];
    [vm postData:[semester data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        SemesterEvaluate *newEvaluate = [SemesterEvaluate parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            [self cleanEvaluatePanel];
            return ;
        }
        self.originSource = newEvaluate;
        [self resetEvaluateContent];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self cleanEvaluatePanel];
        [MEKits handleError:error];
    }];
}

- (void)cleanEvaluatePanel {
    [self.quesPanels removeAllObjects];
    _currentSubClassIndex = 0;_currentSID = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _scroller = nil;_layout = nil;
}

- (void)resetEvaluateContent {
    //prepare data
    NSMutableArray<NSString *>*typeTitles = [NSMutableArray arrayWithCapacity:0];
    NSArray<SEEvaluateType*>*Types = self.originSource.typesArray.copy;
    for (SEEvaluateType *t in Types) {
        [typeTitles addObject:t.title];
    }
    //navigator
    self.subNavigator = [MESubNavigator navigatorWithTitles:typeTitles.copy defaultIndex:self.currentSubClassIndex];
    [self addSubview:self.subNavigator];
    [self.subNavigator makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(ME_SUBNAVGATOR_HEIGHT);
    }];
    //content
    [self addSubview:self.scroller];
    [self.scroller addSubview:self.layout];
    self.layout.backgroundColor = [UIColor pb_randomColor];
    [self.scroller makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subNavigator.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.height.equalTo(self.scroller);
    }];
    //inner content
    int i = 0;MESEQuestionPanel *lastPanel = nil;
    for (SEEvaluateType *t in Types) {
        MESEQuestionPanel *panel = [[MESEQuestionPanel alloc] initWithFrame:CGRectZero];
        panel.backgroundColor = [UIColor pb_randomColor];
        [self.layout addSubview:panel];
        [panel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.layout);
            make.left.equalTo((lastPanel==nil)?self.layout : lastPanel.mas_right);
            make.width.equalTo(MESCREEN_WIDTH);
        }];
        //add reference
        [self.quesPanels addObject:panel];
        //flag
        lastPanel = panel;
        i++;
    }
    
    //right margin
    [self.layout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastPanel.mas_right);
    }];
    
    //callback
    weakify(self)
    self.subNavigator.callback = ^(NSUInteger index, NSUInteger preIndex) {
        strongify(self)
        [self navigatorTriggeredPage:index];
    };
}

#pragma mark --- lazy loading

- (NSMutableArray<MESEQuestionPanel*>*)quesPanels {
    if (!_quesPanels) {
        _quesPanels = [NSMutableArray arrayWithCapacity:0];
    }
    return _quesPanels;
}

- (MEBaseScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[MEBaseScrollView alloc] initWithFrame:CGRectZero];
        _scroller.bounces = true;
        _scroller.delegate = self;
        _scroller.pagingEnabled = true;
        _scroller.showsVerticalScrollIndicator = true;
        _scroller.showsHorizontalScrollIndicator = false;
        _scroller.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _scroller;
}

- (MEBaseScene *)layout {
    if (!_layout) {
        _layout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _layout;
}

#pragma mark --- UIScrollView Delegate ---

- (NSUInteger)currntPageIdx {
    float contentOffset_x = self.scroller.contentOffset.x;
    CGFloat width = floorf(CGRectGetWidth(self.bounds));
    NSUInteger page = (contentOffset_x + (0.5f * width)) / width;
    return page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self scrollViewDidtrigger];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self scrollViewDidtrigger];
    }
}

/**
 ScrollView 触发切换页
 */
- (void)scrollViewDidtrigger {
    NSUInteger curPage = [self currntPageIdx];
    [self.subNavigator willSelectIndex:curPage];
    //reload panel data
    [self reloadQuestionPanel4Index:curPage];
}

/**
 SubNavigator 触发切换页
 */
- (void)navigatorTriggeredPage:(NSUInteger)page {
    NSUInteger curPage = [self currntPageIdx];
    if (curPage == page) {
        return;
    }
    self.currentSubClassIndex = page;
    //切换栏目
    CGPoint offset = CGPointMake(MESCREEN_WIDTH * page, 0);
    [self.scroller setContentOffset:offset animated:false];
    //配置
    [self reloadQuestionPanel4Index:page];
}

/**
 刷新此面板数据
 */
- (void)reloadQuestionPanel4Index:(NSUInteger)page {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
