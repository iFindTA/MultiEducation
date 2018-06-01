//
//  MEDropDownMenu.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEDropDownMenu.h"

/**
 *  按钮中图片的位置
 */
typedef NS_ENUM(NSUInteger, MMImageAlignment) {
    /**
     *  图片在左，默认
     */
    MMImageAlignmentLeft = 0,
    /**
     *  图片在上
     */
    MMImageAlignmentTop,
    /**
     *  图片在下
     */
    MMImageAlignmentBottom,
    /**
     *  图片在右
     */
    MMImageAlignmentRight,
};
@interface MMButton: MEBaseButton
/**
 *  按钮中图片的位置
 */
@property(nonatomic,assign)MMImageAlignment imageAlignment;
/**
 *  按钮中图片与文字的间距
 */
@property(nonatomic,assign)CGFloat spaceBetweenTitleAndImage;
@end

@implementation MMButton

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat space = self.spaceBetweenTitleAndImage;
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);//titleLabel的宽度
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);//titleLabel的高度
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);//imageView的宽度
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);//imageView的高度
    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;//按钮中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat imageCenterX = btnCenterX - titleW/2;//imageView中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat titleCenterX = btnCenterX + imageW/2;//titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）
    
    switch (self.imageAlignment) {
        case MMImageAlignmentTop: {
            self.titleEdgeInsets = UIEdgeInsetsMake(imageH/2+ space/2, -(titleCenterX-btnCenterX), -(imageH/2 + space/2), titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleH/2 + space/2), btnCenterX-imageCenterX, titleH/2+ space/2, -(btnCenterX-imageCenterX));
        }
            break;
        case MMImageAlignmentLeft: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0,  -space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space);
        }
            break;
        case MMImageAlignmentBottom: {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageH/2+ space/2), -(titleCenterX-btnCenterX), imageH/2 + space/2, titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleH/2 + space/2, btnCenterX-imageCenterX,-(titleH/2+ space/2), -(btnCenterX-imageCenterX));
        }
            break;
        case MMImageAlignmentRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + space/2), 0, imageW + space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2));
        }
            break;
        default:
            break;
    }
}

@end

#pragma mark -------------- >>>>>>>: navigationBar

typedef void(^METitlePanelCallback)(BOOL back, BOOL expand);

@interface MEDropDownTitlePanel: MEBaseScene

@property (nonatomic, strong) MMButton *titleBtn;
@property (nonatomic, strong) MEBaseButton *backBtn;

@property (nonatomic, copy) METitlePanelCallback callback;

- (void)closeExpand;

@end

@implementation MEDropDownTitlePanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleBtn];
        [self addSubview:self.backBtn];
        [self.titleBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
            make.height.equalTo(self.mas_height);
        }];
        [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(ME_LAYOUT_MARGIN);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark --- lazy loading

- (MMButton *)titleBtn {
    if (!_titleBtn) {
        UIImage * img_normal = [UIImage imageNamed:@"drop_icon_down"];
        UIImage * img_select = [UIImage imageNamed:@"drop_icon_up"];
        _titleBtn = [MMButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.spaceBetweenTitleAndImage = ME_LAYOUT_MARGIN*0.5;
        _titleBtn.imageAlignment = MMImageAlignmentRight;
//        _titleBtn.backgroundColor = [UIColor pb_randomColor];
        [_titleBtn setTitle:@"往期评价" forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = UIFontPingFangSCBold(METHEME_FONT_TITLE+1);
        [_titleBtn setImage:img_normal forState:UIControlStateNormal];
        [_titleBtn setImage:img_select forState:UIControlStateSelected];
        [_titleBtn setTitleColor:UIColorFromRGB(ME_THEME_COLOR_TEXT) forState:UIControlStateNormal];
        [_titleBtn setTitleColor:UIColorFromRGB(ME_THEME_COLOR_TEXT) forState:UIControlStateSelected];
        [_titleBtn addTarget:self action:@selector(userDidTouchTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (MEBaseButton *)backBtn {
    if (!_backBtn) {
        CGFloat itemSize = 28;
        CGFloat fontSize = METHEME_FONT_TITLE * 1.5;
        NSString *fontName = @"iconfont";
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        NSString *title = @"\U0000e6e2";
        CGSize titleSize = [title pb_sizeThatFitsWithFont:font width:PBSCREEN_WIDTH];
        UIColor *fontColor = pbColorMake(ME_THEME_COLOR_TEXT);
        CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        //btn.backgroundColor = [UIColor pb_randomColor];
        btn.frame = CGRectMake(0, 0, titleSize.width + spacing, itemSize);
        btn.exclusiveTouch = true;
        btn.titleLabel.font = font;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:fontColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userDidTouchBackAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}

#pragma mark --- user interface actions

- (void)userDidTouchTitleAction:(MEBaseButton *)btn {
    btn.selected = !btn.selected;
    if (self.callback) {
        self.callback(false, btn.isSelected);
    }
}

- (void)userDidTouchBackAction {
    if (self.callback) {
        self.callback(true, false);
    }
}

- (void)closeExpand {
    self.titleBtn.selected = false;
}

@end

#pragma mark -------------- >>>>>>>: sub-menu-cell

@interface MEDropListCell: UITableViewCell

@property (nonatomic, strong) MEBaseScene *layout;
@property (nonatomic, strong) MEBaseLabel *title;
@property (nonatomic, strong) MEBaseImageView *access;

- (void)update4ChoosenState:(BOOL)choose;

@end

@implementation MEDropListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.layout];
        [self.layout addSubview:self.title];
        [self.layout addSubview:self.access];
        [self.layout makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.layout).insets(UIEdgeInsetsMake(0, ME_LAYOUT_BOUNDARY, 0, ME_LAYOUT_BOUNDARY));
        }];
        [self.access makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.layout).offset(-ME_LAYOUT_MARGIN);
            make.centerY.equalTo(self.title);
            make.width.height.equalTo(ME_LAYOUT_ICON_HEIGHT*0.6);
        }];
    }
    return self;
}

#pragma mark --- lazy loading

- (MEBaseScene *)layout {
    if (!_layout) {
        _layout = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _layout;
}

- (MEBaseLabel *)title {
    if (!_title) {
        _title = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _title.font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE);
        _title.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _title;
}

- (MEBaseImageView *)access {
    if (!_access) {
        _access = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    }
    return _access;
}

#pragma mark --- user interface actions

- (void)update4ChoosenState:(BOOL)choose {
    UIColor *color = choose ? UIColorFromRGB(ME_THEME_COLOR_VALUE):UIColorFromRGB(ME_THEME_COLOR_TEXT);
    self.title.textColor = color;
    UIImage *icon = [UIImage pb_iconFont:nil withName:@"\U0000e6f5" withSize:ME_LAYOUT_ICON_HEIGHT/MESCREEN_SCALE withColor:color];
    self.access.image = icon;
}

@end

#pragma mark -------------- >>>>>>>: sub-menu

typedef void(^MEDropListCallback)(int semester, int month);

@interface MEDropList: MEBaseScene <UITableViewDelegate, UITableViewDataSource> {
    int sectIndecator[2];
}

@property (nonatomic, strong) MEBaseTableView *sect1Table;
@property (nonatomic, strong) ForwardEvaluateList *source;
@property (nonatomic, strong) MEBaseTableView *sect2Table;

/**
 callback
 */
@property (nonatomic, copy) MEDropListCallback callback;

/**
 保存之前选中
 */
@property (nonatomic, assign) int preSect1, preSect2;

- (void)reset;

@end

@implementation MEDropList

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sect1Table];
        [self addSubview:self.sect2Table];
        [self.sect1Table makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        [self.sect2Table makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
    }
    return self;
}

#pragma mark --- lazy loading

- (MEBaseTableView *)sect1Table {
    if (!_sect1Table) {
        _sect1Table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sect1Table.delegate = self;
        _sect1Table.dataSource = self;
        _sect1Table.tableFooterView = [UIView new];
        //_sect1Table.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
    }
    return _sect1Table;
}

- (MEBaseTableView *)sect2Table {
    if (!_sect2Table) {
        _sect2Table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sect2Table.delegate = self;
        _sect2Table.dataSource = self;
        _sect2Table.tableFooterView = [UIView new];
    }
    return _sect2Table;
}

#pragma mark --- TableView Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger counts = 0;
    if (tableView == self.sect1Table) {
        counts = self.source.listArray.count;
    } else if (tableView  == self.sect2Table) {
        // display months;
        ForwardEvaluate *fe = self.source.listArray[sectIndecator[0]];
        counts = fe.monthsArray.count;
    }
    return counts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ME_LAYOUT_SUBBAR_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"forward_cell";
    MEDropListCell *cell = (MEDropListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MEDropListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger __row = [indexPath row];
    ForwardEvaluate *fe;
    BOOL whehtherChoosen = false;
    if (tableView == self.sect1Table) {
        whehtherChoosen = __row == sectIndecator[0];
        fe = self.source.listArray[__row];
        cell.title.text = fe.name;
        cell.access.hidden = false;
    } else if (tableView == self.sect2Table) {
        whehtherChoosen = __row == sectIndecator[1];
        fe = self.source.listArray[sectIndecator[0]];
        NSArray<Month*>*ms = fe.monthsArray.copy;
        Month *m = ms[__row];
        cell.access.hidden = true;
        cell.title.text = m.name;
    }
    [cell update4ChoosenState:whehtherChoosen];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    int __row = (int)[indexPath row];
    if (tableView == self.sect1Table) {
        if (__row == sectIndecator[0]) {
            return;
        }
        //重置选择行
        sectIndecator[0] = __row;
        sectIndecator[1] = -1;
        if (__row == _preSect1) {
            sectIndecator[1] = _preSect2;
        }
        //reload
        [tableView reloadData];
        [self.sect2Table reloadData];
    } else if (tableView == self.sect2Table) {
        if (__row == sectIndecator[1]) {
            return;
        }
        //重置第二行
        sectIndecator[1] = __row;
        //更改preview selection
        _preSect1 = sectIndecator[0];_preSect2 = sectIndecator[1] = __row;
        //reload
        [tableView reloadData];
        [self userDidTriggeredChangeEvent];
    }
}

#pragma mark --- user interface actions

- (void)reloadData4Source:(ForwardEvaluateList *)list {
    _source = nil;
    self.source = list;
    [self.sect1Table reloadData];
    [self.sect2Table reloadData];
    //default value
    int len = sizeof(sectIndecator)/sizeof(sectIndecator[0]);
    for (int i = 0; i < len; i++) {
        sectIndecator[i] = 0;
    }
    _preSect1 = sectIndecator[0];_preSect2 = sectIndecator[1];
    if (self.callback) {
        self.callback(sectIndecator[0], sectIndecator[1]);
    }
}

- (void)userDidTriggeredChangeEvent {
    if (self.callback) {
        self.callback(sectIndecator[0], sectIndecator[1]);
    }
}

- (void)reset {
    sectIndecator[0] = _preSect1;
    sectIndecator[1] = _preSect2;
    //reload
    [self.sect1Table reloadData];
    [self.sect2Table reloadData];
}

@end

#pragma mark -------------- >>>>>>>: Drop-Menu

CGFloat const ME_DROP_DOWN_LIST_SCALE                                               =   0.3;
NSUInteger const ME_DROP_DOWN_LIST_LINES_MAX                                        =   6;//最多六行
NSUInteger const ME_DROP_DOWN_LIST_LINES_MIN                                        =   3;//最少三行

@interface MEDropDownMenu ()

@property (nonatomic, weak) UIView *fatherView;
@property (nonatomic, strong) UIView *fatherMask;

/**
 导航条
 */
@property (nonatomic, strong) MEDropDownTitlePanel *titlePanel;
@property (nonatomic, strong) MEBaseScene *barLine;
@property (nonatomic, strong) MEBaseScene *statusBar;

/**
 下拉菜单
 */
@property (nonatomic, strong) MEDropList *dropList;
@property (nonatomic, strong) ForwardEvaluateList *sourceList;

/**
 最多的行数
 */
@property (nonatomic, assign) NSUInteger listMaxLines;

@end

@implementation MEDropDownMenu

+ (instancetype)dropDownWithSuperView:(UIView *)view{
    return [[MEDropDownMenu alloc] initWithFrame:CGRectZero fatherView:view];
}

- (instancetype)initWithFrame:(CGRect)frame fatherView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        _fatherView = view;
        _fatherMask = [[UIView alloc] initWithFrame:_fatherView.bounds];
        _fatherMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _fatherMask.hidden = true;
        [_fatherView insertSubview:_fatherMask belowSubview:self];
        
        [self addSubview:self.titlePanel];
        [self addSubview:self.barLine];
        [self addSubview:self.statusBar];
        CGFloat statusHeight = [MEKits statusBarHeight];
        //CGFloat barHeight = statusHeight + ME_HEIGHT_NAVIGATIONBAR;
        [self.statusBar makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(statusHeight);
        }];
        [self.titlePanel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusBar.mas_bottom);
            make.left.bottom.right.equalTo(self);
            //make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
        }];
        [self.barLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
        }];
        //callback
        weakify(self)
        self.titlePanel.callback = ^(BOOL back, BOOL expand) {
            strongify(self)
            if (back) {
                if (self.callback) {
                    self.callback(back, 0, 0);
                }
            } else {
                [self titlePanelExpand:expand];
            }
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)configureMenu:(ForwardEvaluateList *)list {
    //reset max lines
    NSUInteger counts = list.listArray.count;
    counts = (counts < ME_DROP_DOWN_LIST_LINES_MIN) ? ME_DROP_DOWN_LIST_LINES_MIN : counts;
    counts = (counts > ME_DROP_DOWN_LIST_LINES_MAX) ? ME_DROP_DOWN_LIST_LINES_MAX : counts;
    self.listMaxLines = counts;
    //clear reset
    _sourceList = list;
    [self.fatherMask addSubview:self.dropList];
    //[self insertSubview:self.dropList belowSubview:self.titlePanel];
    CGFloat offset = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR;
    [self.dropList makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fatherMask.mas_top).offset(offset);
        make.left.right.equalTo(self);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT * self.listMaxLines);
    }];
    //callback
    weakify(self)
    self.dropList.callback = ^(int sIndex, int mIndex) {
        strongify(self)
        ForwardEvaluate *fe = self.sourceList.listArray[sIndex];
        int32_t semester = fe.semester;
        Month *ms = fe.monthsArray[mIndex];
        int32_t month = ms.month;
        if (self.callback) {
            self.callback(false, semester, month);
        }
        [self.titlePanel closeExpand];
        [self titlePanelExpand:false];
        //更改标题
        NSString *sName = fe.name;
        NSString *mName = ms.name;
        NSString *title = PBFormat(@"%@-%@", sName, mName);
        [self.titlePanel.titleBtn setTitle:title forState:UIControlStateNormal];
        [self.titlePanel.titleBtn setTitle:title forState:UIControlStateSelected];
    };
    //reload
    [self.dropList reloadData4Source:list];
}

#pragma mark --- lazy loading

- (MEDropDownTitlePanel *)titlePanel {
    if (!_titlePanel) {
        _titlePanel = [[MEDropDownTitlePanel alloc] initWithFrame:CGRectZero];
    }
    return _titlePanel;
}

- (MEBaseScene *)barLine {
    if (!_barLine) {
        _barLine = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _barLine.backgroundColor = pbColorMake(PB_NAVIBAR_SHADOW_HEX);
    }
    return _barLine;
}

- (MEBaseScene *)statusBar {
    if (!_statusBar) {
        _statusBar = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _statusBar;
}

- (MEDropList *)dropList {
    if (!_dropList) {
        _dropList = [[MEDropList alloc] initWithFrame:CGRectZero];
    }
    return _dropList;
}

#pragma mark --- user interface actions

- (void)titlePanelExpand:(BOOL)expand {
    //是否展开
    self.fatherMask.hidden = !expand;
    CGFloat padding = (expand? (ME_LAYOUT_SUBBAR_HEIGHT * self.listMaxLines) : 0);
    CGFloat offset = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR + padding;
    [self.dropList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fatherMask.mas_top).offset(offset);
    }];
    weakify(self)
    //*
     [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
         strongify(self)
         [self.fatherMask layoutIfNeeded];
     } completion:^(BOOL finished) {
         strongify(self)
         [self.dropList reset];
     }];
     //*/
    /*
    [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
        strongify(self)
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];//*/
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
