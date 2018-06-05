//
//  MEStudentsPanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentsPanel.h"

#define ME_STUDENT_PANEL_EXPAND                                     20
#define ME_STUDENT_PANEL_ITEM_HEIGHT                                100
#define ME_STUDENT_PANEL_OFFSET                                     5
#define ME_STUDENT_PANEL_NUMPERLINE                                 5
#define ME_STUDENT_PANEL_TAG_START                                  1000

CGFloat const ME_STUDENT_PANEL_HEIGHT = 120;

#pragma mark --- Class:>>>>> 学生遮罩

@interface MEMask: UIView

@property (nonatomic, strong) UIImageView *icon, *mask;
@property (nonatomic, strong) MEBaseLabel *label;

/**
 学生ID
 */
@property (nonatomic, assign) int64_t s_id;

/**
 编辑状态
 */
@property (nonatomic, assign) int32_t status;

- (void)setImageURL:(NSString * _Nullable)url placeholder:(UIImage * _Nullable)image;

@end

@implementation MEMask

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self.icon addSubview:self.mask];
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ME_STUDENT_PANEL_OFFSET*2);
        make.left.equalTo(self).offset(ME_STUDENT_PANEL_OFFSET);
        make.right.equalTo(self).offset(-ME_STUDENT_PANEL_OFFSET);
        make.height.equalTo(self.icon.mas_width);
    }];
    [self.mask makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.icon);
    }];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(ME_STUDENT_PANEL_OFFSET*0.5);
    }];
}

#pragma mark --- lazy loading
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = true;
    }
    return _icon;
}

- (UIImageView *)mask {
    if (!_mask) {
        _mask = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mask.contentMode = UIViewContentModeScaleAspectFill;
        _mask.image = [UIImage imageNamed:@"student_icon_normal"];
    }
    return _mask;
}

- (MEBaseLabel *)label {
    if (!_label) {
        _label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _label.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
        _label.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark --- setter

- (void)setStatus:(int32_t)status {
    if (_status == status) {
        return;
    }
    _status = status;
    [self updateStudentEditState:status];
}

- (void)updateStudentEditState:(MEEvaluateState)state {
    NSString *iconString = @"student_icon_normal";
    if (state == MEEvaluateStateDone) {
        iconString = @"student_icon_done";
    } else if (state == MEEvaluateStateStash) {
        iconString = @"student_icon_stash";
    } else if (state == MEEvaluateStateChoosing) {
        iconString = @"student_icon_editing";
    }
    self.mask.image = [UIImage imageNamed:iconString];
}

/**
 恢复选中之前的状态
 */
- (void)updateState2Origin {
    [self updateStudentEditState:self.status];
}

#pragma mark --- user interface actions

- (void)setImageURL:(NSString * _Nullable)url placeholder:(UIImage *)image {
    if (!url) {
        [self.icon setImage:image];
        return;
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}

@end

#pragma mark --- Class:>>>>> 学生model
//@interface MEStudentItem: NSObject
//
//@property (nonatomic, assign) int64_t sid;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, copy) NSString *name;
//
//@end
//
//@implementation MEStudentItem
//
//@end

/**
 学生点击回调
 */
typedef void(^MEStudentTouchEvent)(int64_t sid);

#pragma mark --- Class:>>>>> 学生横向列表
@interface MEStudentLandscape: MEBaseScene

@property (nonatomic, strong) MEBaseScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;
/**
 所有学生
 */
@property (nonatomic, strong) NSMutableArray<MEMask*> *students;

@property (nonatomic, copy) MEStudentTouchEvent callback;

/**
 上次选中的item学生
 */
@property (nonatomic, strong) MEMask *preChoosenMask;

@end

@implementation MEStudentLandscape

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scroller];
        [self.scroller addSubview:self.layout];
        [self.scroller makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.layout makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scroller);
            make.height.equalTo(self.scroller);
        }];
    }
    return self;
}

#pragma mark --- lazy loading

- (MEBaseScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[MEBaseScrollView alloc] initWithFrame:CGRectZero];
        _scroller.bounces = true;
        _scroller.pagingEnabled = false;
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

- (NSMutableArray <MEMask*>*)students {
    if (!_students) {
        _students = [NSMutableArray arrayWithCapacity:0];
    }
    return _students;
}

#pragma mark --- user interface actions

- (void)updatePanel4Students:(NSArray<MEStudent*>*)studs {
    if (studs.count == 0) {
        NSLog(@"got an empty source");
        return;
    }
    [self.students removeAllObjects];
    //layout sub items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger counts = studs.count;MEMask *lastMask = nil;
    UIImage *placeholder = [UIImage imageNamed:@"appicon_placeholder"];
    CGFloat boundary = ME_LAYOUT_MARGIN;CGFloat itemDistance = ME_LAYOUT_MARGIN;
    CGFloat itemWidth = ceil((MESCREEN_WIDTH-boundary*2-itemDistance*(ME_STUDENT_PANEL_NUMPERLINE-1))/(ME_STUDENT_PANEL_NUMPERLINE));
    for (int i = 0; i < counts; i++) {
        MEStudent *item = studs[i];
        MEMask *student = [[MEMask alloc] initWithFrame:CGRectZero];
        student.s_id = item.id_p;
        student.status = item.status;
        student.tag = ME_STUDENT_PANEL_TAG_START+i;
        student.label.text = item.name;
        NSString *avatar = [MEKits mediaFullPath:item.portrait];
        [student setImageURL:avatar placeholder:placeholder];
        [self.layout addSubview:student];
        [student makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.layout);
            make.left.equalTo(((lastMask==nil)?self.layout:lastMask.mas_right)).offset(((lastMask==nil)?boundary:itemDistance));
            make.width.equalTo(itemWidth);
        }];
        //tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTouchLandscapeItem:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [student addGestureRecognizer:tap];
        //update mask
        [student updateStudentEditState:item.status];
        //add reference
        [self.students addObject:student];
        //flag
        lastMask = student;
    }
    //trailing margin
    [self.layout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastMask).offset(boundary);
    }];
}

- (void)userDidTouchLandscapeItem:(UITapGestureRecognizer *)gesture {
    UIView *view = [gesture view];
    if ([view isKindOfClass:[MEMask class]]|| [view isMemberOfClass:[MEMask class]]) {
        MEMask *mask = (MEMask*)view;
        if (mask == self.preChoosenMask) {
            return;
        }
        //恢复状态
        [self.preChoosenMask updateState2Origin];
        self.preChoosenMask = mask;
        //更新选中状态
        [mask updateStudentEditState:MEEvaluateStateChoosing];
        if (self.callback) {
            self.callback(mask.s_id);
        }
    }
}

/**
 滚动到可显示区域到中间
 */
- (void)scroll2Visiable4SID:(int64_t)sid {
    MEMask *mask;
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            mask = m;
            break;
        }
    }
    if (mask != nil) {
        [self.scroller scrollRectToVisible:mask.frame animated:true];
    }
}

/**
 更新当前学生状态
 */
- (void)updateStudent:(int64_t)sid state:(MEEvaluateState)state {
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            m.status = state;
            break;
        }
    }
}

/**
 预选中当前学生 之前状态保存到pre-state
 */
- (void)preSelectStudent:(int64_t)sid {
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            //恢复状态
            [self.preChoosenMask updateState2Origin];
            //更新状态
            [m updateStudentEditState:MEEvaluateStateChoosing];
            //更新flag
            self.preChoosenMask = m;
            break;
        }
    }
}

@end

#pragma mark --- Class:>>>>> 学生纵向列表
@interface MEStudentPortrait: MEBaseScene

@property (nonatomic, strong) MEBaseScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;
/**
 所有学生
 */
@property (nonatomic, strong) NSMutableArray<MEMask*> *students;

@property (nonatomic, copy) MEStudentTouchEvent callback;

/**
 上次选中的item学生
 */
@property (nonatomic, strong) MEMask *preChoosenMask;

@end

@implementation MEStudentPortrait

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scroller];
        [self.scroller addSubview:self.layout];
        [self.scroller makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.layout makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scroller);
            make.width.equalTo(self.scroller);
        }];
    }
    return self;
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

- (NSMutableArray <MEMask*>*)students {
    if (!_students) {
        _students = [NSMutableArray arrayWithCapacity:0];
    }
    return _students;
}

#pragma mark --- user interface actions

- (void)updatePanel4Students:(NSArray<MEStudent*>*)studs {
    if (studs.count == 0) {
        NSLog(@"got an empty source");
        return;
    }
    [self.students removeAllObjects];
    //layout sub items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger counts = studs.count;MEMask *lastMask = nil;
    UIImage *placeholder = [UIImage imageNamed:@"appicon_placeholder"];
    CGFloat boundary = ME_LAYOUT_MARGIN;CGFloat itemDistance = ME_LAYOUT_MARGIN;
    NSUInteger numPerLine = ME_STUDENT_PANEL_NUMPERLINE;
    CGFloat itemWidth = ceil((MESCREEN_WIDTH-boundary*2-itemDistance*(numPerLine-1))/(numPerLine));
    CGFloat itemHeight = ME_STUDENT_PANEL_ITEM_HEIGHT;
    for (int i = 0; i < counts; i++) {
        MEStudent *item = studs[i];
        NSUInteger __row_idx = i / numPerLine;NSUInteger __col_idx = i % numPerLine;
        NSUInteger offset_x = boundary + (itemWidth+itemDistance)*__col_idx;
        NSUInteger offset_y = itemHeight*__row_idx;
        MEMask *student = [[MEMask alloc] initWithFrame:CGRectZero];
        student.s_id = item.id_p;
        student.status = item.status;
        student.tag = ME_STUDENT_PANEL_TAG_START+i;
        student.label.text = item.name;
        [student setImageURL:item.portrait placeholder:placeholder];
        [self.layout addSubview:student];
        [student makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.layout).offset(offset_y);
            make.left.equalTo(self.layout).offset(offset_x);
            make.width.equalTo(itemWidth);
            make.height.equalTo(itemHeight);
        }];
        //tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTouchPortraitItem:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [student addGestureRecognizer:tap];
        //add reference
        [self.students addObject:student];
        //flag
        lastMask = student;
    }
    //trailing margin
    [self.layout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastMask);
    }];
}

- (void)userDidTouchPortraitItem:(UITapGestureRecognizer *)gesture {
    UIView *view = [gesture view];
    if ([view isKindOfClass:[MEMask class]]|| [view isMemberOfClass:[MEMask class]]) {
        MEMask *mask = (MEMask*)view;
        if (mask == self.preChoosenMask) {
            return;
        }
        //恢复状态
        [self.preChoosenMask updateState2Origin];
        self.preChoosenMask = mask;
        //更新选中状态
        [mask updateStudentEditState:MEEvaluateStateChoosing];
        if (self.callback) {
            self.callback(mask.s_id);
        }
    }
}

/**
 滚动到可显示区域到中间
 */
- (void)scroll2Visiable4SID:(int64_t)sid {
    MEMask *mask;
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            mask = m;
            break;
        }
    }
    if (mask != nil) {
        [self.scroller scrollRectToVisible:mask.frame animated:true];
    }
}

/**
 更新当前学生状态
 */
- (void)updateStudent:(int64_t)sid state:(MEEvaluateState)state {
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            m.status = state;
            break;
        }
    }
}

/**
 预选中当前学生 之前状态保存到pre-state
 */
- (void)preSelectStudent:(int64_t)sid {
    for (MEMask *m in self.students) {
        if (m.s_id == sid) {
            //恢复状态
            [self.preChoosenMask updateState2Origin];
            //更新状态
            [m updateStudentEditState:MEEvaluateStateChoosing];
            //更新flag
            self.preChoosenMask = m;
            break;
        }
    }
}

@end

#pragma mark --- Class:>>>>> 学生Panel

@interface MEStudentsPanel ()

/**
 父View
 */
@property (nonatomic, weak) UIView *father;
@property (nonatomic, weak) UIView *margin;
@property (nonatomic, strong) MEBaseScene *fatherMask;

/**
 所有学生
 */
@property (nonatomic, strong) NSMutableArray<MEStudent*> *students;
/**
 portrait:竖直方向 landscape：水平方向
 */
@property (nonatomic, strong) MEStudentPortrait *portraitScene;
@property (nonatomic, strong) MEStudentLandscape *landscapeScene;
@property (nonatomic, assign) CGFloat portraitSceneHeight;
@property (nonatomic, strong) MEBaseButton *expandBtn;

/**
 当前选择的学生ID
 */
@property (nonatomic, assign) int64_t currentSID;

@end

@implementation MEStudentsPanel

+ (instancetype)panelWithSuperView:(UIView *)view topMargin:(UIView *)margin {
    return [[MEStudentsPanel alloc] initWithFrame:CGRectZero superView:view topMargin:margin];
}

- (id)initWithFrame:(CGRect)frame superView:(UIView *)view topMargin:(UIView *)margin{
    self = [super initWithFrame:frame];
    if (self) {
        _father = view;
        _margin = margin;
        _autoScrollNext = true;
    }
    return self;
}

#pragma mark --- lazy loading

- (NSMutableArray<MEStudent*>*)students {
    if (!_students) {
        _students = [NSMutableArray arrayWithCapacity:0];
    }
    return _students;
}

- (MEStudentPortrait *)portraitScene {
    if (!_portraitScene) {
        _portraitScene = [[MEStudentPortrait alloc] initWithFrame:CGRectZero];
    }
    return _portraitScene;
}

- (MEStudentLandscape *)landscapeScene {
    if (!_landscapeScene) {
        _landscapeScene = [[MEStudentLandscape alloc] initWithFrame:CGRectZero];
    }
    return _landscapeScene;
}

/**
 load students for class
 */
- (void)loadAndConfigure {
    weakify(self)
    MEStudent *s = [[MEStudent alloc] init];
    s.type = self.type;
    s.classId = self.classID;
    s.gradeId = self.gradeID;
    s.semester = self.semester;
    s.month = self.month;
    MEStudentListVM *vm = [[MEStudentListVM alloc] init];
    [vm postData:[s data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEStudentList *list = [MEStudentList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            return ;
        }
        //data source
        [self.students removeAllObjects];
        //预处理数据
        NSMutableArray<MEStudent*>*tmp = [NSMutableArray arrayWithCapacity:0];
        for (MEStudent *s in list.studentsArray) {
            [tmp addObject:s];
        }
        [self.students addObjectsFromArray:tmp.copy];
        [self configurePanel];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

/**
 配置panel
 */
- (void)configurePanel {
    //default id
    self.currentSID = -1;
    //configure subviews
    [self __configureSubviews];
    
    //reload students
    [self.landscapeScene updatePanel4Students:self.students.copy];
    [self.portraitScene updatePanel4Students:self.students.copy];
    
    //event
    weakify(self)
    self.portraitScene.callback = ^(int64_t sid){
        strongify(self)
        if (self.currentSID == sid) {
            return ;
        }
        [self portraitCallbackDidTriggeredChoosing4SID:sid];
    };
    self.landscapeScene.callback = ^(int64_t sid){
        strongify(self)
        if (self.currentSID == sid) {
            return ;
        }
        [self landscapeCallbackDidTriggeredChoosing4SID:sid];
    };
    
    //默认选中下一个待编辑的学生
    [self autoScroll2NextStudent];
}

- (void)__configureSubviews {
    //single height
    CGFloat defaultHeight = ME_STUDENT_PANEL_ITEM_HEIGHT+ME_STUDENT_PANEL_EXPAND;
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.margin.mas_bottom);
        make.left.right.equalTo(self.father);
        make.bottom.equalTo(self.mas_top).offset(defaultHeight);
    }];
    //line
    MEBaseScene *line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    line.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    //expand
    UIImage *image = [UIImage imageNamed:@"student_icon_expand"];
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(expandEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.expandBtn = btn;
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(line.mas_top);
        make.width.equalTo(ME_STUDENT_PANEL_ITEM_HEIGHT);
        make.height.equalTo(btn.mas_width).multipliedBy(0.2);
    }];
    //水平方向的panel 一行高
    [self addSubview:self.landscapeScene];
    [self.landscapeScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(ME_STUDENT_PANEL_ITEM_HEIGHT);
    }];
    //竖直方向的panel
    NSInteger numLines = [self lines4Expand];
    self.portraitSceneHeight = numLines * ME_STUDENT_PANEL_ITEM_HEIGHT;
    [self addSubview:self.portraitScene];
    self.portraitScene.hidden = true;
    [self.portraitScene makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(self.portraitSceneHeight);
        make.bottom.equalTo(btn.mas_top);
    }];
    //父view背景
    _fatherMask = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    _fatherMask.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    _fatherMask.hidden = true;
    [self.father insertSubview:_fatherMask belowSubview:self];
    [self.fatherMask makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.father);
    }];
    //如果仅有一行则隐藏展开
    if (numLines == 1) {
        self.expandBtn.hidden = true;
    }
}

#pragma mark --- User Interface Actions

- (NSInteger)lines4Expand {
    NSUInteger numPerLine = ME_STUDENT_PANEL_NUMPERLINE;
    NSInteger tmpNum = self.students.count / numPerLine;
    if (tmpNum == 0) {
        tmpNum = 1;
    }
    CGFloat height = MESCREEN_HEIGHT * 0.65;
    NSInteger num = height / ME_STUDENT_PANEL_ITEM_HEIGHT;
    return MIN(tmpNum, num);
}

- (void)expandEvent:(MEBaseButton *)btn {
    btn.selected = !btn.selected;
    //是否展开
    BOOL expand = btn.selected;
    self.fatherMask.hidden = !expand;
    self.portraitScene.hidden = !expand;
    CGFloat singleHeight = ME_STUDENT_PANEL_ITEM_HEIGHT + ME_STUDENT_PANEL_EXPAND;
    CGFloat expandHeight = self.portraitSceneHeight + ME_STUDENT_PANEL_EXPAND;
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_top).offset(expand?expandHeight:singleHeight);
    }];
    weakify(self)
    /*
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        strongify(self)
        [self updatePortraitVisiable];
    }];
     //*/
    [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        strongify(self)
        [self updatePortraitVisiable];
    }];
}

/**
 portrait触发回调
 */
- (void)portraitCallbackDidTriggeredChoosing4SID:(int64_t)sid {
    int64_t preStudentID = self.currentSID;
    self.currentSID = sid;
    //更新状态
    [self.landscapeScene preSelectStudent:sid];
    [self updateLandscapeVisiable];
    [self initiativeCollapsePortraitMenu];
    if (self.callback) {
        self.callback(sid, preStudentID);
    }
}

/**
 landscape触发回调
 */
- (void)landscapeCallbackDidTriggeredChoosing4SID:(int64_t)sid {
    int64_t preStudentID = self.currentSID;
    self.currentSID = sid;
    //更新状态
    [self.portraitScene preSelectStudent:sid];
    //此处不用更新 展开后更新即可
    //[self updatePortraitVisiable];
    if (self.callback) {
        self.callback(sid, preStudentID);
    }
}

/**
 更新竖直方向可显示区域
 */
- (void)updatePortraitVisiable {
    [self.portraitScene scroll2Visiable4SID:self.currentSID];
}

/**
 更新水平方向可显示区域
 */
- (void)updateLandscapeVisiable {
    [self.landscapeScene scroll2Visiable4SID:self.currentSID];
}

/**
 选择单个menu后 收起竖直方向的scene
 */
- (void)initiativeCollapsePortraitMenu {
    [self expandEvent:self.expandBtn];
}

/**
 获取下一个待编辑的学生 包括未编辑和已暂存
 */
- (MEStudent * _Nullable)fetchNextTobeEditing {
    MEStudent *s = nil;
    for (MEStudent *stdn in self.students) {
        if (stdn.status != MEEvaluateStateDone) {
            s = stdn;
            break;
        }
    }
    return s;
}

- (void)updateStudent:(int64_t)sid status:(MEEvaluateState)state {
    for (MEStudent *s in self.students) {
        if (s.id_p == sid) {
            s.status = state;
            break;
        }
    }
    [self.portraitScene updateStudent:sid state:state];
    [self.landscapeScene updateStudent:sid state:state];
    // 自动切换下一个
    if (self.autoScrollNext && state==MEEvaluateStateDone) {
        [self autoScroll2NextStudent];
    }
}

/**
 自动选择下一个待编辑的学生
 */
- (void)autoScroll2NextStudent {
    MEStudent *next = [self fetchNextTobeEditing];
    if (!next) {
        if (self.editCallback) {
            self.editCallback(true);
        }
        //如果都已完成 则默认选择第一个
        MEStudent *first = self.students.firstObject;
        next = first;
    }
    int64_t preStudentID = self.currentSID;
    self.currentSID = next.id_p;
    [self updatePortraitVisiable];
    [self updateLandscapeVisiable];
    [self.portraitScene preSelectStudent:self.currentSID];
    [self.landscapeScene preSelectStudent:self.currentSID];
    if (self.callback) {
        self.callback(next.id_p, preStudentID);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
