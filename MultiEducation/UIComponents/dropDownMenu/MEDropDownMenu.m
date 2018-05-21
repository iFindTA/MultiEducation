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

#pragma mark -------------- >>>>>>>: sub-menu

@interface MEDropList: MEBaseScene <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MEBaseTableView *sect1Table;
@property (nonatomic, strong) ForwardEvaluateList *source;

@end

@implementation MEDropList

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sect1Table];
        [self.sect1Table makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark --- lazy loading

- (MEBaseTableView *)sect1Table {
    if (!_sect1Table) {
        _sect1Table = [[MEBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
    }
    return _sect1Table;
}

#pragma mark --- TableView Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ME_LAYOUT_SUBBAR_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"forward_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end

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
//        self.backgroundColor = [UIColor pb_randomColor];
        [self.statusBar makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.titlePanel.mas_top);
        }];
        [self.titlePanel makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
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
                    self.callback(back);
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
    //clear reset
    _sourceList = list;
    [self.fatherMask addSubview:self.dropList];
    CGFloat offset = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR;
    [self.dropList makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fatherMask.mas_top).offset(offset);
        make.left.right.equalTo(self);
        make.height.equalTo(MESCREEN_HEIGHT).multipliedBy(0.5);
    }];
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
        _dropList.backgroundColor = [UIColor pb_randomColor];
    }
    return _dropList;
}

#pragma mark --- user interface actions

- (void)titlePanelExpand:(BOOL)expand {
    //是否展开
    self.fatherMask.hidden = !expand;
    CGFloat offset = [MEKits statusBarHeight] + ME_HEIGHT_NAVIGATIONBAR + (expand? MESCREEN_HEIGHT*0.5 : 0);
    [self.dropList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fatherMask.mas_top).offset(offset);
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
        strongify(self)
        [self.fatherView layoutIfNeeded];
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
