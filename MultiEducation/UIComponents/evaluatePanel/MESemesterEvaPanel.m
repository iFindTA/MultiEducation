//
//  MESemesterEvaPanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/29.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESemesterEvaPanel.h"
#import "MESubNavigator.h"

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价问题单选 slice
@class MECheckSlice;
typedef void(^MECheckSliceCallback)(MECheckSlice *slice);
@interface MECheckSlice : MEBaseScene

@property (nonatomic, assign) int64_t e_id;
@property (nonatomic, copy) NSString *e_title;

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) MEBaseImageView *checkBox;
@property (nonatomic, strong) MEBaseLabel *label;
@property (nonatomic, strong) MEBaseScene *titleScene;

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable;

@property (nonatomic, copy) MECheckSliceCallback callback;

@end

@implementation MECheckSlice

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable {
    return [[MECheckSlice alloc] initWithFrame:CGRectZero title:title editable:editable];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title editable:(BOOL)editable{
    self = [super initWithFrame:frame];
    if (self) {
        _e_title = title.copy;
        _editable = editable;
        [self addSubview:self.checkBox];
        [self addSubview:self.titleScene];
        [self.titleScene addSubview:self.label];
        self.label.text = title;
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.checkBox makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.width.equalTo(self.checkBox.mas_height);
    }];
    [self.titleScene makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBox.mas_right);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN);
    }];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleScene).insets(UIEdgeInsetsMake(0, ME_LAYOUT_MARGIN, 0, 0));
    }];
}

#pragma mark --- getter

- (MEBaseImageView *)checkBox {
    if (!_checkBox) {
        _checkBox = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        _checkBox.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
        _checkBox.image = [UIImage imageNamed:@"evaluate_icon_check"];
    }
    return _checkBox;
}

- (MEBaseScene *)titleScene {
    if (!_titleScene) {
        _titleScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _titleScene.backgroundColor = UIColorFromRGB(0xF8F8F8);
    }
    return _titleScene;
}

- (MEBaseLabel *)label {
    if (!_label) {
        _label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = UIFontPingFangSC(METHEME_FONT_TITLE-1);
        _label.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _label;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.editable) {
        [MEKits makeToast:@"您不能编辑当前内容！"];
        return;
    }
    
    if (self.callback) {
        __weak typeof(self) weakSelf = self;
        self.callback(weakSelf);
    }
}

#pragma mark --- setter

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    _checked = checked;
    UIColor *checkBgColor = checked?UIColorFromRGB(ME_THEME_COLOR_VALUE):UIColorFromRGB(ME_THEME_COLOR_LINE);
    self.checkBox.backgroundColor = checkBgColor;
    UIColor *fontColor = checked?UIColorFromRGB(ME_THEME_COLOR_VALUE):UIColorFromRGB(ME_THEME_COLOR_TEXT);
    [self.label setTextColor:fontColor];
    UIColor *bgColor = checked?UIColorFromRGB(0xCCE2FA):UIColorFromRGB(0xF8F8F8);
    self.titleScene.backgroundColor = bgColor;
    [self layoutIfNeeded];
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价问题item

/**
 问题选项编辑回调 如果回调说明该项有编辑 则需要暂存
 */
@class MESEQuestionItem;
typedef void(^MEQuestionItemCallback)(MESEQuestionItem *item);

@interface MESEQuestionItem: MEBaseScene

/**
 问题item
 */
@property (nonatomic, strong) SEEvaluateItem *quesItem;
@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) MEBaseScene *titleScene;

/**
 切片组合引用
 */
@property (nonatomic, strong) NSMutableArray<MECheckSlice*>*slices;

/**
 当前选中的item选项 空表示没有该问题选项没有编辑过
 */
@property (nonatomic, strong) MECheckSlice *currentSlice;

/**
 问题 是否已答题(可依据此判断是否已编辑)
 */
@property (nonatomic, assign) BOOL answered;
@property (nonatomic, copy) MEQuestionItemCallback editCallback;

- (id)initWithFrame:(CGRect)frame withQuestion:(SEEvaluateItem *)ques editable:(BOOL)editable;

/**
 获取新的已答题答案 模型
 */
- (SEEvaluateItem * _Nullable)generateNewQuestion;

@end

static NSString * checkSet[3] = {
    @"做到了",
    @"有进步",
    @"要加油"
};

@implementation MESEQuestionItem

- (id)initWithFrame:(CGRect)frame withQuestion:(SEEvaluateItem *)ques editable:(BOOL)editable {
    self = [super initWithFrame:frame];
    if (self) {
        _quesItem = ques;
        _editable = editable;
        [self __configureQuestionItemSubviews];
    }
    return self;
}

- (void)__configureQuestionItemSubviews {
    [self addSubview:self.titleScene];
    [self.titleScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    self.titleLab.text = self.quesItem.title;
    [self.titleScene addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleScene).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, ME_LAYOUT_BOUNDARY, ME_LAYOUT_MARGIN, ME_LAYOUT_BOUNDARY));
    }];
    
    //slice
    int cap = sizeof(checkSet)/sizeof(checkSet[0]);
    MECheckSlice *lastSlice;
    for (int i = 0; i < cap; i++) {
        MECheckSlice *slice = [[MECheckSlice alloc] initWithFrame:CGRectZero title:checkSet[i] editable:self.editable];
        slice.tag = i;
        [self addSubview:slice];
        [slice makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastSlice==nil)?self.titleLab.mas_bottom : lastSlice.mas_bottom).offset(ME_LAYOUT_MARGIN*0.5);
            make.left.right.equalTo(self);
            make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        }];
        //add reference
        [self.slices addObject:slice];
        //whether checked
        BOOL whetherAnswered = (self.quesItem.answer - 1 == i);
        slice.checked = whetherAnswered;
        //如果已选择 则保存当前选择的
        if (whetherAnswered) {//已暂存过
            self.currentSlice = slice;
        }
        //callback
        weakify(self)
        slice.callback = ^(MECheckSlice *s) {
            strongify(self)
            [self userDidTouchQuestionSlice:s];
        };
        //reference
        lastSlice = slice;
    }
    //bottom margin
    UIView *lastMargin = lastSlice;
    if (lastSlice == nil) {
        lastMargin = self.titleLab;
    }
    [lastMargin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    //本题是否已作答
    self.answered = (self.currentSlice != nil);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark --- lazy loading

- (MEBaseScene *)titleScene {
    if (!_titleScene) {
        _titleScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _titleScene;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE-1);
        _titleLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _titleLab.numberOfLines = 0;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLab;
}

#pragma mark --- user interface actions

- (SEEvaluateItem *)generateNewQuestion {
    
    
    return nil;
}

- (void)userDidTouchQuestionSlice:(MECheckSlice *)s {
    self.answered = true;
    if (s == self.currentSlice) {
        NSLog(@"选择了相同的选项!");
        return;
    }
    self.currentSlice = s;
    //单选题
    for (MECheckSlice *o in self.slices) {
        BOOL checked = (o == s && o.tag == s.tag);
        [o setChecked:checked];
    }
    //用户编辑了某一项 则回调暂存
    if (self.editCallback) {
        __weak typeof(self) weakSelf = self;
        self.editCallback(weakSelf);
    }
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价Panel

@interface MESEQuestionPanel: MEBaseScene

/**
 数据源
 */
@property (nonatomic, strong) SEEvaluateType *source;
@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) MEBaseScrollView *panelScroller;
@property (nonatomic, strong) MEBaseScene *panelLayout;
@property (nonatomic, strong) MEBaseScene *testLayout;

@property (nonatomic, strong) MEBaseButton *submitBtn;

+ (instancetype)panelWithSource:(SEEvaluateType*)type editable:(BOOL)editable;

@end

@implementation MESEQuestionPanel

+(instancetype)panelWithSource:(SEEvaluateType *)type editable:(BOOL)editable {
    return [[MESEQuestionPanel alloc] initWithFrame:CGRectZero source:type editable:editable];
}

- (id)initWithFrame:(CGRect)frame source:(SEEvaluateType *)type editable:(BOOL)editable {
    self = [super initWithFrame:frame];
    if (self) {
        _source = type;
        _editable = editable;
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    [self addSubview:self.panelScroller];
    [self.panelScroller addSubview:self.panelLayout];
    [self.panelScroller makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.panelLayout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.panelScroller);
        make.width.equalTo(self.panelScroller);
    }];
    /*for test layout inner
    [self.panelLayout addSubview:self.testLayout];
    [self.testLayout makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.panelLayout);
        make.height.equalTo(MESCREEN_HEIGHT);
    }];//*/
    
    NSArray<SEEvaluateSubType*>*subTypes = self.source.subTypesArray.copy;
    MEBaseScene *lastSection;MESEQuestionItem *lastItem;
    for (SEEvaluateSubType *sub in subTypes) {
        //分区
        MEBaseScene *section = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        [self.panelLayout addSubview:section];
        [section makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastItem==nil)?self.panelLayout:lastItem.mas_bottom);
            make.left.right.equalTo(self.panelLayout);
            make.height.equalTo(adoptValue(50));
        }];
        MEBaseLabel *sectLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        sectLabel.font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
        sectLabel.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        sectLabel.text = sub.title;
        [section addSubview:sectLabel];
        [sectLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(section).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN, ME_LAYOUT_BOUNDARY, 0, ME_LAYOUT_BOUNDARY));
        }];
        //reference
        lastSection = section;
        
        //*sub questions
        NSArray<SEEvaluateItem *>*items = sub.itemsArray.copy;
        for (int i = 0; i < items.count; i++) {
            SEEvaluateItem *item = items[i];
            MESEQuestionItem *slice = [[MESEQuestionItem alloc] initWithFrame:CGRectZero withQuestion:item editable:self.editable];
            [self.panelLayout addSubview:slice];
            [slice makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((i==0)? lastSection.mas_bottom : lastItem.mas_bottom);
                make.left.right.equalTo(self.panelLayout);
            }];
            
            //add reference
            lastItem = slice;
        }
    }
    //editable
    UIView *lastMargin = lastItem;
    if (lastItem == nil) {
        lastMargin = lastSection;
    }
    if (self.editable) {
        [self.panelLayout addSubview:self.submitBtn];
        [self.submitBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastMargin==nil)?self.panelLayout:lastMargin.mas_bottom).offset(ME_LAYOUT_MARGIN);
            make.left.equalTo(self.panelLayout).offset(ME_LAYOUT_MARGIN);
            make.right.equalTo(self.panelLayout).offset(-ME_LAYOUT_MARGIN);
            make.height.equalTo(ME_SUBNAVGATOR_HEIGHT);
        }];
        
        lastMargin = self.submitBtn;
    }
    
    //bottom margin
    [self.panelLayout makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastMargin.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
    }];
}

#pragma mark --- lazy loading

- (MEBaseScrollView *)panelScroller {
    if (!_panelScroller) {
        _panelScroller = [[MEBaseScrollView alloc] initWithFrame:CGRectZero];
        _panelScroller.bounces = true;
        _panelScroller.pagingEnabled = false;
        _panelScroller.showsVerticalScrollIndicator = true;
        _panelScroller.showsHorizontalScrollIndicator = false;
        _panelScroller.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _panelScroller;
}

- (MEBaseScene *)panelLayout {
    if (!_panelLayout) {
        _panelLayout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _panelLayout;
}

- (MEBaseScene *)testLayout {
    if (!_testLayout) {
        _testLayout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _testLayout;
}

- (MEBaseButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = UIFontPingFangSCBold(METHEME_FONT_TITLE+1);
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        btn.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
        btn.layer.masksToBounds = true;
        btn.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userDidTouchSESubmitEvent) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn = btn;
    }
    return _submitBtn;
}

#pragma mark --- user interface actions

- (void)userDidTouchSESubmitEvent {
    
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
    _scroller = nil;_layout = nil;_subNavigator = nil;
}

- (void)resetEvaluateContent {
    [self cleanEvaluatePanel];
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
    [self.scroller makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subNavigator.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [self.layout makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.height.equalTo(self.scroller);
    }];
    //inner content
    BOOL editable = (self.currentUser.userType == MEPBUserRole_Teacher);
    int i = 0;MESEQuestionPanel *lastPanel = nil;
    for (SEEvaluateType *t in Types) {
        MESEQuestionPanel *panel = [MESEQuestionPanel panelWithSource:t editable:editable];
        //panel.backgroundColor = [UIColor pb_randomColor];
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
        _scroller.showsVerticalScrollIndicator = false;
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