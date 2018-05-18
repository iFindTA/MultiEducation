//
//  MEStudentsPanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentsPanel.h"

#pragma mark --- Class:>>>>> 学生遮罩

@interface MEMask: UIView

@property (nonatomic, strong) UIImageView *icon, *mask;

- (void)setImageURL:(NSString *)url placeholder:(UIImage * _Nullable)image;

@end

@implementation MEMask

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.mask];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.mask makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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

#pragma mark --- Class:>>>>> 学生Panel

#define ME_STUDENT_PANEL_EXPAND                                     20
#define ME_STUDENT_PANEL_ITEM_HEIGHT                                100

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
@property (nonatomic, strong) NSMutableArray<MEStudentItem*> *students;
/**
 portrait:竖直方向 landscape：水平方向
 */
@property (nonatomic, strong) MEBaseScene *portraitScene;
@property (nonatomic, strong) MEBaseScene *landscapeScene;
@property (nonatomic, assign) CGFloat portraitSceneHeight;

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

- (NSArray<MEStudentItem*>*)generateTest {
    NSMutableArray *m = [NSMutableArray arrayWithCapacity:0];
    @autoreleasepool {
        for (int i = 0; i < 50; i++) {
            MEStudentItem *item = [[MEStudentItem alloc] init];
            item.name = PBFormat(@"学生-%d", i);
            item.avatar = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526620027520&di=6e5ed1894c7d192e4a04e4e105f1baa8&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014f88572803236ac7253812365e80.jpg";
            [m addObject:item];
        }
    }
    return m.copy;
}

#pragma mark --- lazy loading

- (NSMutableArray<MEStudentItem*>*)students {
    if (!_students) {
        _students = [NSMutableArray arrayWithCapacity:0];
    }
    return _students;
}

- (MEBaseScene *)portraitScene {
    if (!_portraitScene) {
        _portraitScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _portraitScene.backgroundColor = [UIColor pb_randomColor];
    }
    return _portraitScene;
}

- (MEBaseScene *)landscapeScene {
    if (!_landscapeScene) {
        _landscapeScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _landscapeScene.backgroundColor = [UIColor pb_randomColor];
    }
    return _landscapeScene;
}

/**
 配置panel
 */
- (void)configurePanel {
    NSArray *tests = [self generateTest];
    [self.students addObjectsFromArray: tests];
    
    [self __configureSubviews];
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
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
