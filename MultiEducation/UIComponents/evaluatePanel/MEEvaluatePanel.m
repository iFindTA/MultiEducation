//
//  MEEvaluatePanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESubNavigator.h"
#import "MEEvaluatePanel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UITextView+MaxLength/UITextView+MaxLength.h>
#import <UITextView+Placeholder/UITextView+Placeholder.h>

CGFloat const ME_QUESTION_INPUT_HEIGHT = 185;

@class MEOption;
typedef void(^MEOptionItemCallback)(MEOption *opt);

#pragma mark --- >>>>>>>>>>>>>>>>>>> 问题Item 选项
@interface MEOption : MEBaseScene

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) MEBaseImageView *checkBox;
@property (nonatomic, strong) MEBaseLabel *label;
@property (nonatomic, strong) MEBaseScene *titleScene;

/**
 用户输入
 */
@property (nonatomic, strong) MEBaseScene *inputScene;
@property (nonatomic, strong) UITextView *input;

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable;

@property (nonatomic, copy) MEOptionItemCallback callback;

@end

@implementation MEOption

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable {
    return [[MEOption alloc] initWithFrame:CGRectZero title:title editable:editable];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title editable:(BOOL)editable{
    self = [super initWithFrame:frame];
    if (self) {
        _editable = editable;
        [self addSubview:self.checkBox];
        [self addSubview:self.titleScene];
        [self.titleScene addSubview:self.label];
        self.label.text = title;
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

- (MEBaseScene *)inputScene {
    if (!_inputScene) {
        _inputScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _inputScene.backgroundColor = UIColorFromRGB(0xF9F9F9);
    }
    return _inputScene;
}

- (UITextView *)input {
    if (!_input) {
        _input = [[UITextView alloc] initWithFrame:CGRectZero];
        _input.keyboardType = UIKeyboardTypeNamePhonePad;
        _input.font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE+1);
        _input.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _input.placeholderColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _input;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.editable) {
        [SVProgressHUD showInfoWithStatus:@"您不能编辑当前内容！"];
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

#pragma mark --- >>>>>>>>>>>>>>>>>>> 问题Item panel
@class MEQuestionItem;
/**
 问题选项编辑回调 如果回调说明该项有编辑 则需要暂存
 */
typedef void(^MEQuestionItemCallback)(MEQuestionItem *item);

@interface MEQuestionItem: MEBaseScene

/**
 是否可编辑
 */
@property (nonatomic, assign) BOOL editable;

/**
 问题source
 */
@property (nonatomic, strong) EvaluateQuestion *source;
@property (nonatomic, assign) NSUInteger quesIndex;

/**
 问题选项
 */
@property (nonatomic, strong) NSMutableArray<MEOption*>*itemOpts;

/**
 当前选中的item选项 空表示没有该问题选项没有编辑过
 */
@property (nonatomic, strong) MEOption *currentOpt;

/**
 问题 是否已答题(可依据此判断是否已编辑)
 */
@property (nonatomic, assign) BOOL answered;
@property (nonatomic, copy) MEQuestionItemCallback editCallback;

+ (instancetype)itemWithQuestion:(EvaluateQuestion *)ques index:(NSUInteger)index editable:(BOOL)editable;

/**
 获取新的已答题答案 模型
 */
- (EvaluateQuestion * _Nullable)generateNewAnswer;

@end

@implementation MEQuestionItem

+ (instancetype)itemWithQuestion:(EvaluateQuestion *)ques index:(NSUInteger)index editable:(BOOL)editable {
    return [[MEQuestionItem alloc] initWithFrame:CGRectZero question:ques index:index editable:editable];
}

- (instancetype)initWithFrame:(CGRect)frame question:(EvaluateQuestion *)ques index:(NSUInteger)index editable:(BOOL)editable {
    self = [super initWithFrame:frame];
    if (self) {
        _source = ques;
        _quesIndex = index;
        _editable = editable;
        [self __configureQuestionItemSubviews];
    }
    return self;
}

- (void)__configureQuestionItemSubviews {
    //title
    UIFont *font = UIFontPingFangSCBold(METHEME_FONT_TITLE-1);
    UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    NSString *title = PBFormat(@"%lu.%@", (unsigned long)self.quesIndex, self.source.title);
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.textColor = fontColor;
    label.text = title;
    [self addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self).offset(-ME_LAYOUT_BOUNDARY);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    //问题选项
    [self.itemOpts removeAllObjects];
    NSArray <EvaluateItem*>*opts = self.source.itemsArray.copy;
    int i=0; MEOption *lastOpt = nil;CGFloat offset = ME_LAYOUT_MARGIN*0.5;
    for (EvaluateItem *item in opts) {
        MEOption *opt = [[MEOption alloc] initWithFrame:CGRectZero title:item.title editable:self.editable];
        opt.tag = i;
        opt.checked = item.checked;
        [self addSubview:opt];
        [self.itemOpts addObject:opt];
        [opt makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastOpt==nil)?label.mas_bottom:lastOpt.mas_bottom).offset((lastOpt==nil)?0:offset);
            make.left.right.equalTo(self);
            make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
        }];
        //如果已选择 则保存当前选择的
        if (item.checked) {
            self.currentOpt = opt;
        }
        //callback
        weakify(self)
        opt.callback = ^(MEOption *opt){
            strongify(self)
            [self userDidTouchQuestionOption:opt];
        };
        lastOpt = opt;
        i++;
    }
    
    //bottom margin
    [lastOpt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-offset);
    }];
}

#pragma mark --- getter

- (NSMutableArray<MEOption*>*)itemOpts {
    if (!_itemOpts) {
        _itemOpts = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemOpts;
}

- (EvaluateQuestion *_Nullable)generateNewAnswer {
    
    return nil;
}

#pragma mark --- user interface actions

- (void)userDidTouchQuestionOption:(MEOption *)opt {
    if (opt == self.currentOpt) {
        NSLog(@"选择了相同的选项!");
        return;
    }
    //已编辑
    self.answered = true;
    self.currentOpt = opt;
    if (self.source.checkType == 1) {
        //单选题
        for (MEOption *o in self.itemOpts) {
            BOOL checked = (o == opt && o.tag == opt.tag);
            [o setChecked:checked];
        }
    } else if (self.source.checkType == 2) {
        //多选题
        opt.checked = !opt.checked;
    }
    //用户编辑了某一项 则回调暂存
    if (self.editCallback) {
        __weak typeof(self) weakSelf = self;
        self.editCallback(weakSelf);
    }
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价问题panel

@interface MEQuestionPanel: MEBaseScene

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) MEBaseScene *layout;

/**
 本页是否可编辑 eg. 老师不能编辑在家里的内容 家长不能编辑在学校的内容 园务不能编辑所有内容
 */
@property (nonatomic, assign) BOOL editable;

/**
 本页所有问题
 */
@property (nonatomic, strong) NSArray<EvaluateQuestion*>*questions;

/**
 正在编辑 暂存问题panel
 */
@property (nonatomic, strong) NSMutableArray<MEQuestionItem *>*stashQuesIDs;

/**
 重置问题
 */
- (void)reset4Questions:(NSArray<EvaluateQuestion*> *)ques;

/**
 获取暂存的问题
 */
- (NSArray<EvaluateQuestion*>*_Nullable)fetchStashQuestions;

@end

@implementation MEQuestionPanel

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

- (void)reset4Questions:(NSArray<EvaluateQuestion*> *)ques {
    [self.layout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _questions = [NSArray arrayWithArray:ques];
    //reset
    int i = 1;MEQuestionItem *lastItem = nil;
    for (EvaluateQuestion *q in ques) {
        MEQuestionItem *item = [[MEQuestionItem alloc] initWithFrame:CGRectZero question:q index:i editable:self.editable];
        [self.layout addSubview:item];
        [item makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastItem==nil)?self:lastItem.mas_bottom);
            make.left.right.equalTo(self.layout);
        }];
        //编辑回调
        weakify(self)
        item.editCallback = ^(MEQuestionItem *item){
            strongify(self)
            if (![self.stashQuesIDs containsObject:item]) {
                [self.stashQuesIDs addObject:item];
            }
        };
        lastItem = item;
        i++;
    }
    //bottom margin
    [self.layout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastItem.mas_bottom).offset(ME_LAYOUT_MARGIN);
    }];
}

#pragma mark --- lazy loading

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
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

- (NSMutableArray<MEQuestionItem*>*)stashQuesIDs {
    if (!_stashQuesIDs) {
        _stashQuesIDs = [NSMutableArray arrayWithCapacity:0];
    }
    return _stashQuesIDs;
}

#pragma mark --- getter

- (NSArray<EvaluateQuestion*>*_Nullable)fetchStashQuestions {
    if (self.stashQuesIDs.count == 0) {
        return nil;
    }
    NSMutableArray<EvaluateQuestion*>*newSets = [NSMutableArray arrayWithCapacity:0];
    for (MEQuestionItem *i in self.stashQuesIDs) {
        EvaluateQuestion *ques = [i generateNewAnswer];
        [newSets addObject:ques];
    }
    return newSets.copy;
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>> 评价整体Panel

@interface MEEvaluatePanel ()

/**
 当前学生ID
 */
@property (nonatomic, assign) int64_t currentSID;

/**
 获取到的元数据
 */
@property (nonatomic, strong) GrowthEvaluate *originSource;

/**
 当前分类
 */
@property (nonatomic, assign) MEEvaluateType currentSubClassType;
@property (nonatomic, strong) MESubNavigator *subNavigator;

@property (nonatomic, strong) MEQuestionPanel *homePanel;
@property (nonatomic, strong) MEQuestionPanel *schoolPanel;

@end

@implementation MEEvaluatePanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor pb_randomColor];
    }
    return self;
}

#pragma mark --- user interface actions

- (void)didChanged2Student4ID:(int64_t)sid {
    if (self.currentSID == sid) {
        return;
    }
    
    GrowthEvaluate *e = [[GrowthEvaluate alloc] init];
    e.studentId = sid;
}

- (void)exchangedStudent2Evaluate:(GrowthEvaluate *)growth {
    if (growth.studentId == self.currentSID) {
        return;
    }
    weakify(self)
    MEStudentInfoVM *vm = [[MEStudentInfoVM alloc] init];
    [vm postData:[growth data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        GrowthEvaluate *newEvaluate = [GrowthEvaluate parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
            return ;
        }
        self.originSource = newEvaluate;
        [self resetEvaluateContent];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

- (void)resetEvaluateContent {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *titles = @[@"在家里", @"在学校"];
    BOOL parent = self.currentUser.userType == MEPBUserRole_Parent;
    self.currentSubClassType = parent ? MEEvaluateTypeHome : MEEvaluateTypeSchool;
    self.subNavigator = [MESubNavigator navigatorWithTitles:titles defaultIndex:self.currentSubClassType];
    [self addSubview:self.subNavigator];
    [self.subNavigator makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(ME_SUBNAVGATOR_HEIGHT);
    }];
    weakify(self)
    self.subNavigator.callback = ^(NSUInteger index, NSUInteger preIndex) {
        BOOL showParent = index == 0;strongify(self)
        if (showParent) {
            [self bringSubviewToFront:self.homePanel];
        } else {
            [self bringSubviewToFront:self.schoolPanel];
        }
    };
    //home
    [self addSubview:self.homePanel];
    self.homePanel.editable = [self homePanelEditable];
    [self.homePanel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subNavigator.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [self addSubview:self.schoolPanel];
    self.schoolPanel.editable = [self schoolPanelEditable];
    [self.schoolPanel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subNavigator.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    //判断角色放置
    if (parent) {
        [self bringSubviewToFront:self.homePanel];
    } else {
        [self bringSubviewToFront:self.schoolPanel];
    }
    //reset content
    [self.homePanel reset4Questions:self.originSource.homeQuestionsArray.copy];
    [self.schoolPanel reset4Questions:self.originSource.schoolQuestionsArray.copy];
}

#pragma mark --- lazy loading

- (MEQuestionPanel *)homePanel {
    if (!_homePanel) {
        _homePanel = [[MEQuestionPanel alloc] initWithFrame:CGRectZero];
    }
    return _homePanel;
}

- (MEQuestionPanel *)schoolPanel {
    if (!_schoolPanel) {
        _schoolPanel = [[MEQuestionPanel alloc] initWithFrame:CGRectZero];
    }
    return _schoolPanel;
}

#pragma mark --- getter

- (BOOL)homePanelEditable {
    return (self.currentUser.userType == MEPBUserRole_Parent);
}

- (BOOL)schoolPanelEditable {
    return (self.currentUser.userType == MEPBUserRole_Teacher);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
