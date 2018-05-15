//
//  MEIndexNavigationBar.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "UIView+Utils.h"
#import "MEIndexNavigationBar.h"

static NSUInteger ME_INDEX_HEADER_FONT_MAX                     =   18;
static NSUInteger ME_INDEX_HEADER_FONT_MIN                     =   16;
#define INDEX_SEARCH_TINTCOLOR                                  0xCCCCCC

@interface MEIndexNavigationBar () <UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSArray <NSString*>*barTitles;

@property (nonatomic, strong) UIFont *selectFont, *normalFont;
@property (nonatomic, strong) UIColor *selectColor, *normalColor;
@property (nonatomic, strong) NSMutableArray <MEBaseButton*>*barItems;
@property (nonatomic, assign) NSUInteger currentSelectIndex;
@property (nonatomic, strong) MEBaseScene *flagScene;

@property (nonatomic, strong) MEBaseButton *noticeBtn;
@property (nonatomic, strong) MEBaseButton *historyBtn;

@property (nonatomic, strong) MEBaseScene *searchScene;
@property (nonatomic, strong) MEBaseScene *itemScene;
@property (nonatomic, strong) MEBaseImageView *searchIcon;
@property (nonatomic, strong) UITextField *searchTFD;
@property (nonatomic, strong) MEBaseButton *cancelBtn;
@property (nonatomic, strong) MASConstraint *searchRightConstraint;

@end

@implementation MEIndexNavigationBar

+ (instancetype)indexNavigationBarWithTitles:(NSArray<NSString *> *)titles {
    MEIndexNavigationBar *bar = [[MEIndexNavigationBar alloc] initWithFrame:CGRectZero titles:titles];
    return bar;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectFont = UIFontPingFangSCBold(ME_INDEX_HEADER_FONT_MAX);
        self.normalFont = UIFontPingFangSCMedium(ME_INDEX_HEADER_FONT_MIN);
        self.selectColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        self.normalColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        self.barTitles = [NSArray arrayWithArray:titles];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.searchScene];
        [self addSubview:self.itemScene];
        [self __initIndexNavigationBarSubviews];
    }
    return self;
}

- (void)__initIndexNavigationBarSubviews {
    //search bar
    [self.searchScene addSubview:self.searchTFD];
    [self.searchScene addSubview:self.cancelBtn];
    [self updatePlaceholder:@"小蝌蚪找妈妈"];
    CGFloat cancelSize = 50;
    [self.searchTFD remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.searchScene);
        make.right.equalTo(self.searchScene).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchRightConstraint) {
            self.searchRightConstraint = make.right.equalTo(self).offset(-cancelSize-20).priority(UILayoutPriorityRequired);
        }
    }];
    [self.searchRightConstraint deactivate];
    [self.cancelBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.searchTFD);
        make.left.equalTo(self.searchTFD.mas_right).offset(ME_LAYOUT_MARGIN);
        make.width.equalTo(cancelSize);
    }];
    //prepare
    [self.barTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        UIFont *font = (idx == self.currentSelectIndex)?self.selectFont:self.normalFont;
        UIColor *textColor = (idx == self.currentSelectIndex)?self.selectColor:self.normalColor;
        btn.titleLabel.font = font;
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(indexNavigationBarTitleItemTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemScene addSubview:btn];
        [self.barItems addObject:btn];
    }];
    //历史
    UIImage *icon = [UIImage imageNamed:@"index_header_history"];
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(indexNavigationBarHistoryTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.itemScene addSubview:btn];self.historyBtn = btn;
//    icon = [UIImage imageNamed:@"index_header_msg"];
//    btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:icon forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(indexNavigationBarNoticeTouchEvent) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn];self.noticeBtn = btn;
    
    //flag
    [self.itemScene addSubview:self.flagScene];
    
    self.currentSelectIndex = 0;
}

- (NSMutableArray<MEBaseButton*>*)barItems {
    if (!_barItems) {
        _barItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _barItems;
}

- (MEBaseButton *)fetchCurrentSelectItem {
    __block MEBaseButton *btn;
    for (MEBaseButton *b in self.barItems) {
        if (b.tag == self.currentSelectIndex) {
            btn = b;
        }
    }
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.itemScene makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];
    [self.searchScene makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(self.itemScene.mas_top);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    CGFloat start_x = ME_LAYOUT_MARGIN * 2;
    CGFloat right_offset = ME_LAYOUT_BOUNDARY + (ME_LAYOUT_ICON_HEIGHT+ME_LAYOUT_MARGIN) * 2;
    CGFloat allWidth = MESCREEN_WIDTH - start_x - right_offset;
    NSUInteger itemWidth = allWidth/self.barItems.count;
    NSUInteger itemHeight = ME_HEIGHT_TABBAR * 0.5;
    [self.barItems enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemScene).offset(start_x + (itemWidth)*idx);
            make.bottom.equalTo(self.itemScene).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(itemWidth);
            make.height.equalTo(itemHeight);
        }];
    }];
    
    [self.historyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.itemScene).offset(-ME_LAYOUT_MARGIN);
        make.bottom.equalTo(self.itemScene).offset(-ME_LAYOUT_MARGIN+(ME_LAYOUT_ICON_HEIGHT-itemHeight)*0.5);
        make.width.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
//    [self.noticeBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.historyBtn.mas_left).offset(-ME_LAYOUT_MARGIN*2);
//        make.bottom.equalTo(self).offset(-ME_LAYOUT_MARGIN);
//        make.width.height.equalTo(30);
//    }];
}

- (void)updateMasconstraints:(BOOL)begin {
    begin?[self.searchRightConstraint activate]:[self.searchRightConstraint deactivate];
    [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark --- update state

- (void)updateFontStateExcept:(MEBaseButton *)sender {
    [UIView animateWithDuration:ME_ANIMATION_DURATION delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.barItems enumerateObjectsUsingBlock:^(MEBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[obj titleLabel] setFont:((obj.tag == sender.tag)?self.selectFont:self.normalFont)];
            [[obj titleLabel] setTextColor:((obj.tag == sender.tag)?self.selectColor:self.normalColor)];
            [obj setTitleColor:((obj.tag == sender.tag)?self.selectColor:self.normalColor) forState:UIControlStateNormal];
            if (obj == sender) {
                self.currentSelectIndex = idx;
            }
        }];
    } completion:nil];
}

- (void)setCurrentSelectIndex:(NSUInteger)currentSelectIndex {
    _currentSelectIndex = currentSelectIndex;
    [self updateFlagPosition];
}

- (void)updateFlagPosition {
    [self.flagScene remakeConstraints:^(MASConstraintMaker *make) {
        MEBaseButton *btn = [self fetchCurrentSelectItem];
        make.bottom.equalTo(self.itemScene);
        make.centerX.equalTo(btn.mas_centerX);
        make.size.equalTo(CGSizeMake(ME_HEIGHT_TABBAR, ME_LAYOUT_LINE_HEIGHT*2));
    }];
}

- (void)scrollDidScroll2Page:(NSUInteger)page {
    NSUInteger totalCounts = self.barItems.count;
    if (page >= totalCounts) {
        //NSLog(@"边界 不做处理！");
        return;
    }
    if (self.currentSelectIndex == page) {
        return;
    }
    self.currentSelectIndex = page;
    for (MEBaseButton *btn in self.barItems) {
        [[btn titleLabel] setFont:((btn.tag == page)?self.selectFont:self.normalFont)];
        [[btn titleLabel] setTextColor:((btn.tag == page)?self.selectColor:self.normalColor)];
        [btn setTitleColor:((btn.tag == page)?self.selectColor:self.normalColor) forState:UIControlStateNormal];
    }
}

#pragma mark --- Touch Event

- (void)indexNavigationBarTitleItemTouchEvent:(MEBaseButton *)btn {
    [self updateFontStateExcept:btn];
    if (self.indexNavigationBarItemCallback) {
        self.indexNavigationBarItemCallback(btn.tag);
    }
}

- (void)indexNavigationBarHistoryTouchEvent {
    if (self.indexNavigationBarOtherCallback) {
        self.indexNavigationBarOtherCallback(MEIndexNavigationTypeHistory);
    }
}

- (void)indexNavigationBarNoticeTouchEvent {
    if (self.indexNavigationBarOtherCallback) {
        self.indexNavigationBarOtherCallback(MEIndexNavigationTypeNotice);
    }
}

#pragma mark --- getter

- (NSArray *)indexNavigationBarTitles {
    return [NSArray arrayWithArray:self.barTitles];
}

- (MEBaseScene *)flagScene {
    if (!_flagScene) {
        _flagScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _flagScene.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    }
    return _flagScene;
}

- (MEBaseScene *)searchScene {
    if (!_searchScene) {
        _searchScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _searchScene.backgroundColor = [UIColor clearColor];
    }
    return _searchScene;
}

- (MEBaseScene *)itemScene {
    if (!_itemScene) {
        _itemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _itemScene.layer.shadowColor = UIColorFromRGB(0xDEDEDE).CGColor;
        _itemScene.layer.shadowOffset = CGSizeMake(0, 2);
        _itemScene.layer.shadowOpacity = 0.5;
        _itemScene.layer.shadowRadius = 4;
    }
    return _itemScene;
}

//- (UISearchBar *)searchBar {
//    if (!_searchBar) {
//        UIFont *font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
//        UIColor *fontColor = [UIColor whiteColor];
//        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        _searchBar.delegate = self;
//        _searchBar.translucent = true;
//        //字体颜色
//        _searchBar.tintColor = fontColor;
//        _searchBar.barTintColor = fontColor;
//        //设置背景图是为了去掉上下黑线
//        _searchBar.backgroundImage = [[UIImage alloc] init];
//        // 设置SearchBar的颜色主题为白色
//        _searchBar.placeholder = @"小蝌蚪找妈妈";
//        _searchBar.barStyle = UISearchBarStyleDefault;
//        UIImage *bgImage = [UIImage imageNamed:@"search_bar_bg"];
//        [_searchBar setSearchFieldBackgroundImage:bgImage forState:UIControlStateNormal];
//        UIImage *icon = [UIImage imageNamed:@"search_bar_magnifier"];
//        [_searchBar setImage:icon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//        [_searchBar setSearchTextPositionAdjustment:UIOffsetMake(ME_LAYOUT_MARGIN, 0)];
//        UIView *view = [_searchBar valueForKey:@"searchField"];
//        if (view) {
//            UITextField *tfd = (UITextField*)view;
//            tfd.font = font;
//            tfd.textColor = fontColor;
//        }
//    }
//    return _searchBar;
//}

- (UIView *)leftView {
    CGRect bounds = CGRectMake(0, 0, ME_LAYOUT_SUBBAR_HEIGHT, ME_LAYOUT_SUBBAR_HEIGHT);
    UIView *left = [[UIView alloc] initWithFrame:bounds];
    UIImage *icon = [UIImage imageNamed:@"search_bar_magnifier"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    [left addSubview:iconView];
    [iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(left.mas_centerX);
        make.centerY.equalTo(left.mas_centerY);
    }];
    return left;
}

- (UITextField *)searchTFD {
    if (!_searchTFD) {
        UIFont *font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
        UIColor *fontColor = UIColorFromRGB(INDEX_SEARCH_TINTCOLOR);
        _searchTFD = [[UITextField alloc] initWithFrame:CGRectZero];
//        _searchTFD.backgroundColor = UIColorFromRGB(0x4A8AD0);
        _searchTFD.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_BG_GRAY);
        _searchTFD.returnKeyType = UIReturnKeySearch;
        _searchTFD.delegate = self;
        _searchTFD.font = font;
        _searchTFD.textColor = fontColor;
        _searchTFD.tintColor = fontColor;
        _searchTFD.leftView = [self leftView];
        _searchTFD.leftViewMode = UITextFieldViewModeAlways;
        _searchTFD.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTFD.layer.cornerRadius = ME_LAYOUT_ICON_HEIGHT * 0.5;
        _searchTFD.layer.masksToBounds = true;
        [_searchTFD addTarget:self action:@selector(textDidChangeInput:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchTFD;
}

- (MEBaseButton *)cancelBtn {
    if (!_cancelBtn) {
        UIColor *textColor = UIColorFromRGB(INDEX_SEARCH_TINTCOLOR);
        _cancelBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        _cancelBtn.titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_cancelBtn setTitleColor:textColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(endSearchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

#pragma mark --- User Interface Actions

- (void)updatePlaceholder:(NSString *)p {
    //placeholder
    UIFont *font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    UIColor *fontColor = UIColorFromRGB(INDEX_SEARCH_TINTCOLOR);
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:p];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:fontColor
                        range:NSMakeRange(0, p.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(0, p.length)];
    self.searchTFD.attributedPlaceholder = placeholder;
}

- (void)endSearchAction {
    self.searchTFD.text = nil;
    [self.searchTFD endEditing:true];
}

#pragma mark --- UITextField Delegate
//TODO:获取焦点应：弹出搜索历史，覆盖页面， 收起tabBar
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self updateMasconstraints:true];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self updateMasconstraints:false];
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *keyword = textField.text;
    if (keyword.length == 0) {
        return false;
    }
    NSDictionary *params = NSDictionaryOfVariableBindings(keyword);
    NSString *urlString = @"profile://root@MESubClassProfile";
    NSError *error = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:error];
    
    return true;
}

- (void)textDidChangeInput:(UITextField *)tfd {
    if (tfd == self.searchTFD) {
        if (tfd.text.length > 20) {
            tfd.text = [tfd.text substringToIndex:20];
        }
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
