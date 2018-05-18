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

- (void)setImageURL:(NSString *)url placeholder:(UIImage * _Nullable)image;

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
    }
    return _icon;
}

- (UIImageView *)mask {
    if (!_mask) {
        _mask = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mask.contentMode = UIViewContentModeScaleAspectFill;
        _mask.image = [UIImage imageNamed:@"student_icon_mask"];
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

#pragma mark --- user interface actions

- (void)setImageURL:(NSString *)url placeholder:(UIImage *)image {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}

@end

#pragma mark --- Class:>>>>> 学生model
@interface MEStudentItem: NSObject

@property (nonatomic, assign) int64_t sid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;

@end

@implementation MEStudentItem

@end

/**
 学生点击回调
 */
typedef void(^MEStudentTouchEvent)(int64_t sid, NSInteger index);

#pragma mark --- Class:>>>>> 学生横向列表
@interface MEStudentLandscape: MEBaseScene

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;
/**
 所有学生
 */
@property (nonatomic, strong) NSMutableArray<MEStudentItem*> *students;

@property (nonatomic, copy) MEStudentTouchEvent callback;

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

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
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

- (NSMutableArray <MEStudentItem*>*)students {
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
    //convert student to item
    @autoreleasepool {
        for (MEStudent *s in studs) {
            MEStudentItem *item = [[MEStudentItem alloc] init];
            item.avatar = s.portrait;
            item.name = s.name;
            item.sid = s.id_p;
            [self.students addObject:item];
        }
    }
    //layout sub items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger counts = self.students.count;MEMask *lastMask = nil;
    UIImage *placeholder = [UIImage imageNamed:@"appicon_placeholder"];
    CGFloat boundary = ME_LAYOUT_MARGIN;CGFloat itemDistance = ME_LAYOUT_MARGIN;
    CGFloat itemWidth = ceil((MESCREEN_WIDTH-boundary*2-itemDistance*(ME_STUDENT_PANEL_NUMPERLINE-1))/(ME_STUDENT_PANEL_NUMPERLINE));
    for (int i = 0; i < counts; i++) {
        MEStudentItem *item = self.students[i];
        MEMask *student = [[MEMask alloc] initWithFrame:CGRectZero];
        student.tag = ME_STUDENT_PANEL_TAG_START+i;
        student.label.text = item.name;
        [student setImageURL:item.avatar placeholder:placeholder];
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
        NSUInteger __tag = mask.tag;
        MEStudentItem *s = self.students[__tag-ME_STUDENT_PANEL_TAG_START];
        if (self.callback) {
            self.callback(s.sid, __tag);
        }
    }
}

/**
 滚动到可显示区域到中间
 */
- (void)scroll2Visiable4SID:(int64_t)sid index:(NSInteger)index {
    if ((index - ME_STUDENT_PANEL_TAG_START) < self.students.count) {
        UIView *view = [self.layout viewWithTag:index];
        if (view != nil) {
            //CGRect bounds = [self convertRect:view.frame toView:self.scroller];
            [self.scroller scrollRectToVisible:view.frame animated:true];
        }
    }
}

@end

#pragma mark --- Class:>>>>> 学生纵向列表
@interface MEStudentPortrait: MEBaseScene

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;
/**
 所有学生
 */
@property (nonatomic, strong) NSMutableArray<MEStudentItem*> *students;

@property (nonatomic, copy) MEStudentTouchEvent callback;

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

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
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

- (NSMutableArray <MEStudentItem*>*)students {
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
    //convert student to item
    @autoreleasepool {
        for (MEStudent *s in studs) {
            MEStudentItem *item = [[MEStudentItem alloc] init];
            item.avatar = s.portrait;
            item.name = s.name;
            item.sid = s.id_p;
            [self.students addObject:item];
        }
    }
    //layout sub items
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger counts = self.students.count;MEMask *lastMask = nil;
    UIImage *placeholder = [UIImage imageNamed:@"appicon_placeholder"];
    CGFloat boundary = ME_LAYOUT_MARGIN;CGFloat itemDistance = ME_LAYOUT_MARGIN;
    NSUInteger numPerLine = ME_STUDENT_PANEL_NUMPERLINE;
    CGFloat itemWidth = ceil((MESCREEN_WIDTH-boundary*2-itemDistance*(numPerLine-1))/(numPerLine));
    CGFloat itemHeight = ME_STUDENT_PANEL_ITEM_HEIGHT;
    for (int i = 0; i < counts; i++) {
        MEStudentItem *item = self.students[i];
        NSUInteger __row_idx = i / numPerLine;NSUInteger __col_idx = i % numPerLine;
        NSUInteger offset_x = boundary + (itemWidth+itemDistance)*__col_idx;
        NSUInteger offset_y = itemHeight*__row_idx;
        MEMask *student = [[MEMask alloc] initWithFrame:CGRectZero];
        student.tag = ME_STUDENT_PANEL_TAG_START+i;
        student.label.text = item.name;
        [student setImageURL:item.avatar placeholder:placeholder];
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
        NSUInteger __tag = mask.tag;
        MEStudentItem *s = self.students[__tag-ME_STUDENT_PANEL_TAG_START];
        if (self.callback) {
            self.callback(s.sid, __tag);
        }
    }
}

/**
 滚动到可显示区域到中间
 */
- (void)scroll2Visiable4SID:(int64_t)sid index:(NSInteger)index {
    if ((index - ME_STUDENT_PANEL_TAG_START) < self.students.count) {
        UIView *view = [self.layout viewWithTag:index];
        if (view != nil) {
            [self.scroller scrollRectToVisible:view.frame animated:true];
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

/**
 班级ID
 */
@property (nonatomic, assign) int64_t classID;

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
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MEStudentsPanel

+ (instancetype)panelWithClassID:(int64_t)clsID superView:(UIView *)view topMargin:(UIView *)margin {
    return [[MEStudentsPanel alloc] initWithFrame:CGRectZero classID:clsID superView:view topMargin:margin];
}

- (id)initWithFrame:(CGRect)frame classID:(int64_t)cid superView:(UIView *)view topMargin:(UIView *)margin{
    self = [super initWithFrame:frame];
    if (self) {
        _classID = cid;
        _father = view;
        _margin = margin;
    }
    return self;
}

- (NSArray<MEStudent*>*)generateTest {
    NSMutableArray *m = [NSMutableArray arrayWithCapacity:0];
    @autoreleasepool {
        for (int i = 0; i < 50; i++) {
            MEStudent *item = [[MEStudent alloc] init];
            item.name = PBFormat(@"学生-%d", i);
            item.portrait = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526635321255&di=d07d6dbfbc7c05f9d9aff396c08e9fae&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fcb8065380cd79123c3edb18eab345982b2b7803e.jpg";
            [m addObject:item];
        }
    }
    return m.copy;
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
        _portraitScene.backgroundColor = [UIColor pb_randomColor];
    }
    return _portraitScene;
}

- (MEStudentLandscape *)landscapeScene {
    if (!_landscapeScene) {
        _landscapeScene = [[MEStudentLandscape alloc] initWithFrame:CGRectZero];
        _landscapeScene.backgroundColor = [UIColor pb_randomColor];
    }
    return _landscapeScene;
}

/**
 load students for class
 */
- (void)loadAndConfigure {
    weakify(self)
    MEStudentListVM *vm = [[MEStudentListVM alloc] init];
    [vm postData:[NSData data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEStudentList *list = [MEStudentList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            return ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

/**
 配置panel
 */
- (void)configurePanel {
    NSArray *tests = [self generateTest];
    [self.students addObjectsFromArray: tests];
    //default id
    self.currentIndex = ME_STUDENT_PANEL_TAG_START;
    self.currentSID = self.students.firstObject.id_p;
    //configure subviews
    [self __configureSubviews];
    
    //reload students
    [self.landscapeScene updatePanel4Students:self.students];
    [self.portraitScene updatePanel4Students:self.students];
    
    //event
    weakify(self)
    self.portraitScene.callback = ^(int64_t sid, NSInteger index){
        strongify(self)
        self.currentSID = sid;
        self.currentIndex = index;
        [self updateLandscapeVisiable];
        [self initiativeCollapsePortraitMenu];
    };
    self.landscapeScene.callback = ^(int64_t sid, NSInteger index){
        strongify(self)
        self.currentSID = sid;
        self.currentIndex = index;
        //此处不用更新 展开后更新即可
        //[self updatePortraitVisiable];
    };
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
    btn.backgroundColor = [UIColor pb_randomColor];
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
    self.portraitSceneHeight = [self lines4Expand] * ME_STUDENT_PANEL_ITEM_HEIGHT;
    [self addSubview:self.portraitScene];
    self.portraitScene.hidden = true;
    [self.portraitScene makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(self.portraitSceneHeight);
        make.bottom.equalTo(btn.mas_top);
    }];
}

#pragma mark --- User Interface Actions

- (NSInteger)lines4Expand {
    CGFloat height = MESCREEN_HEIGHT * 0.65;
    NSInteger num = height / ME_STUDENT_PANEL_ITEM_HEIGHT;
    return num;
}

- (void)expandEvent:(MEBaseButton *)btn {
    btn.selected = !btn.selected;
    //是否展开
    BOOL expand = btn.selected;
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
 更新竖直方向可显示区域
 */
- (void)updatePortraitVisiable {
    [self.portraitScene scroll2Visiable4SID:self.currentSID index:self.currentIndex];
}

/**
 更新水平方向可显示区域
 */
- (void)updateLandscapeVisiable {
    [self.landscapeScene scroll2Visiable4SID:self.currentSID index:self.currentIndex];
}

/**
 选择单个menu后 收起竖直方向的scene
 */
- (void)initiativeCollapsePortraitMenu {
    [self expandEvent:self.expandBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
