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
#import <IQKeyboardManager/IQTextView.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

CGFloat const ME_QUESTION_INPUT_HEIGHT = 185;
NSUInteger const ME_QUESTION_INPUT_MAXLENGTH = 50;

@class MEQuestionSlice;
typedef void(^MEQuestionSliceItemCallback)(MEQuestionSlice *opt);

#pragma mark --- >>>>>>>>>>>>>>>>>>> 问题Item 选项
@interface MEQuestionSlice : MEBaseScene<UITextViewDelegate>

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) MEBaseImageView *checkBox;
@property (nonatomic, strong) MEBaseLabel *label;
@property (nonatomic, strong) MEBaseScene *titleScene;

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable;

@property (nonatomic, copy) MEQuestionSliceItemCallback callback;

@end

@implementation MEQuestionSlice

+ (instancetype)optionWithTitle:(NSString *)title editable:(BOOL)editable {
    return [[MEQuestionSlice alloc] initWithFrame:CGRectZero title:title editable:editable];
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

#pragma mark --- >>>>>>>>>>>>>>>>>>> 问题Item 输入选项
@interface MEQuesInputSlice : MEQuestionSlice

@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *placeholderString;

/**
 用户输入
 */
@property (nonatomic, strong) MEBaseScene *inputScene;
@property (nonatomic, strong) IQTextView *input, *inputPlaceholer;
@property (nonatomic, strong) MEBaseScene *inputAccess;
@property (nonatomic, assign) NSUInteger maxInputLength;

+ (instancetype)optionWithPlaceholder:(NSString *)placeholder editable:(BOOL)editable maxLength:(NSUInteger)len quesTitle:(NSString *)title;

@end

@implementation MEQuesInputSlice

+ (instancetype)optionWithPlaceholder:(NSString *)holder editable:(BOOL)editable maxLength:(NSUInteger)len quesTitle:(NSString *)title{
    return [[MEQuesInputSlice alloc] initWithFrame:CGRectZero placeholder:holder editable:editable maxLength:len quesTitle:title];
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)holder editable:(BOOL)editable maxLength:(NSUInteger)len quesTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = editable;
        _questionTitle = title.copy;
        _maxInputLength = len;
        _placeholderString = holder.copy;
        [self addSubview:self.inputScene];
        [self.inputScene addSubview:self.input];
        self.input.delegate = self;
        self.input.placeholder = holder;
        self.input.maxLength = MAX(len, ME_QUESTION_INPUT_MAXLENGTH);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.inputScene makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(ME_LAYOUT_MARGIN*0.5, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN*0.5, ME_LAYOUT_MARGIN));
    }];
    [self.input makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputScene);
    }];
}

#pragma mark --- lazy loading

- (MEBaseScene *)inputScene {
    if (!_inputScene) {
        _inputScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _inputScene.backgroundColor = UIColorFromRGB(0xF9F9F9);
    }
    return _inputScene;
}

- (IQTextView *)input {
    if (!_input) {
        _input = [[IQTextView alloc] initWithFrame:CGRectZero];
        _input.backgroundColor = [UIColor clearColor];
        _input.keyboardType = UIKeyboardTypeNamePhonePad;
        _input.font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE+1);
        _input.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        //_input.placeholderColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)) {
            _input.inputAccessoryView = self.inputAccess;
        }
    }
    return _input;
}

- (MEBaseScene *)inputAccess {
    if (!_inputAccess) {
        CGRect bounds = CGRectMake(0, 0, MESCREEN_WIDTH, ME_QUESTION_INPUT_HEIGHT);
        _inputAccess = [[MEBaseScene alloc] initWithFrame:bounds];
        UIFont *font = UIFontPingFangSC(METHEME_FONT_TITLE-1);
        UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        label.font = font;
        label.textColor = fontColor;
        label.text = PBFormat(@"%@:%lu字以内", self.questionTitle, MAX(ME_QUESTION_INPUT_MAXLENGTH, self.maxInputLength));
        [_inputAccess addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_inputAccess);
            make.left.equalTo(_inputAccess).offset(ME_LAYOUT_MARGIN);
            make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
        }];
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        [btn setTitleColor:fontColor forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doneInputEvent) forControlEvents:UIControlEventTouchUpInside];
        [_inputAccess addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_inputAccess);
            make.right.equalTo(_inputAccess).offset(-ME_LAYOUT_MARGIN);
            make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
        }];
        //bg
        MEBaseScene *bg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        bg.backgroundColor = UIColorFromRGB(0xF9F9F9);
        [_inputAccess addSubview:bg];
        [bg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_inputAccess).insets(UIEdgeInsetsMake(ME_LAYOUT_ICON_HEIGHT, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN, ME_LAYOUT_MARGIN));
        }];
        //textview
        IQTextView *placeholder = [[IQTextView alloc] initWithFrame:CGRectZero];
        placeholder.editable = false;
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE+1);
        placeholder.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        placeholder.placeholder = self.placeholderString;
        placeholder.maxLength = MAX(ME_QUESTION_INPUT_MAXLENGTH, self.maxInputLength);
        [bg addSubview:placeholder];
        [placeholder makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bg);
        }];
        self.inputPlaceholer = placeholder;
    }
    return _inputAccess;
}

#pragma mark --- UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!self.editable) {
        [SVProgressHUD showInfoWithStatus:@"您不能编辑当前内容！"];
        return false;
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0) {
        if (self.callback) {
            __weak typeof(self) weakSelf = self;
            self.callback(weakSelf);
        }
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *tempInputs = textView.text;
    NSUInteger maxLen = MAX(ME_QUESTION_INPUT_MAXLENGTH, self.maxInputLength);
    if (tempInputs.length >= maxLen) {
        self.inputPlaceholer.text = [tempInputs substringToIndex:maxLen];
        return;
    }
    self.inputPlaceholer.text = tempInputs;
}

#pragma mark --- user interface actions

- (void)doneInputEvent {
    [self.input endEditing:true];
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
@property (nonatomic, strong) NSMutableArray<MEQuestionSlice*>*itemOpts;

/**
 当前选中的item选项 空表示没有该问题选项没有编辑过
 */
@property (nonatomic, strong) MEQuestionSlice *currentOpt;

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
    int i=0; MEQuestionSlice *lastOpt = nil;CGFloat offset = ME_LAYOUT_MARGIN*0.5;
    [self.itemOpts removeAllObjects];
    int checkType = self.source.checkType;
    if (checkType == 3) {
        MEQuesInputSlice *inputOpt = [[MEQuesInputSlice alloc] initWithFrame:CGRectZero placeholder:self.source.placeholder editable:self.editable maxLength:self.source.maxLength quesTitle:self.source.title];
        inputOpt.tag = i;
        [self addSubview:inputOpt];
        [inputOpt makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(ME_QUESTION_INPUT_HEIGHT);
        }];
        lastOpt = inputOpt;
    } else {
        NSArray <EvaluateItem*>*opts = self.source.itemsArray.copy;
        for (EvaluateItem *item in opts) {
            MEQuestionSlice *opt = [[MEQuestionSlice alloc] initWithFrame:CGRectZero title:item.title editable:self.editable];
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
            opt.callback = ^(MEQuestionSlice *opt){
                strongify(self)
                [self userDidTouchQuestionOption:opt];
            };
            lastOpt = opt;
            i++;
        }
    }
    
    //bottom margin
    [lastOpt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-offset);
    }];
}

#pragma mark --- getter

- (NSMutableArray<MEQuestionSlice*>*)itemOpts {
    if (!_itemOpts) {
        _itemOpts = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemOpts;
}

- (EvaluateQuestion *_Nullable)generateNewAnswer {
    
    return nil;
}

#pragma mark --- user interface actions

- (void)userDidTouchQuestionOption:(MEQuestionSlice *)opt {
    if (opt == self.currentOpt) {
        NSLog(@"选择了相同的选项!");
        return;
    }
    //已编辑
    self.answered = true;
    self.currentOpt = opt;
    if (self.source.checkType == 1) {
        //单选题
        for (MEQuestionSlice *o in self.itemOpts) {
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

@property (nonatomic, strong) MEBaseScrollView *scroller;
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

@property (nonatomic, weak) UIView *fatherView;

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

@property (nonatomic, strong) MEBaseScene *inputMask;

@end

@implementation MEEvaluatePanel

- (void)dealloc {
    [self uninstallKeyBoradEvents];
}

- (id)initWithFrame:(CGRect)frame father:(nonnull UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        _fatherView = view;
        CGRect bounds = _fatherView.bounds;
        _inputMask = [[MEBaseScene alloc] initWithFrame:bounds];
        _inputMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _inputMask.hidden = true;
        [self.fatherView insertSubview:_inputMask aboveSubview:self];
        self.backgroundColor = [UIColor pb_randomColor];
        [self registerKeyboradEvents];
    }
    return self;
}

- (void)registerKeyboradEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__keyboradWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)uninstallKeyBoradEvents {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)__keyboradWillShow:(NSNotification *)notify {
    NSLog(@"keyborad:%@", notify);
    [self.fatherView bringSubviewToFront:self.inputMask];
    CGRect endBounds = [[[notify userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    BOOL hide = fabs(endBounds.origin.y - MESCREEN_HEIGHT) < ME_LAYOUT_MARGIN;
    self.inputMask.hidden = hide;
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
