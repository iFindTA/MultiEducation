//
//  MEBabyPhotoHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoHeader.h"

@interface MEBabyPhotoHeader() {
    NSArray *_titles;
    
    UIButton *_selectedBtn; // selecting btn
}

@property (nonatomic, strong) MEBaseScene *markLine;    //mark choose whice view

@end

@implementation MEBabyPhotoHeader

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super init];
    if (self) {
        _titles = titles;
        [self customSubviews];
    }
    return self;
}

- (void)customSubviews {
    
    CGFloat leftSpace = 20.f;
    CGFloat btnWidth = 60;
    CGFloat betSpace = MESCREEN_WIDTH - 2 * leftSpace - _titles.count * btnWidth;
    
    MEBaseButton *preBtn;
    for (int i = 0; i < _titles.count; i++) {
        MEBaseButton *btn = [[MEBaseButton alloc] init];
        [btn setTitle: [_titles objectAtIndex: i] forState: UIControlStateNormal];
        btn.tag = 100 + i;
        btn.titleLabel.font = UIFontPingFangSC(16);
        [btn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [btn addTarget: self action: @selector(buttonTouchEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        if (!preBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).mas_offset(leftSpace);
                make.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-4);
                make.width.mas_equalTo(btnWidth);
            }];
            _selectedBtn = btn;
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(preBtn.mas_right).mas_offset(betSpace);
                make.top.bottom.mas_equalTo(preBtn);
                make.width.mas_equalTo(btnWidth);
            }];
            
            [self addSubview: btn];
            
            preBtn = btn;
        }
    }
    
    [self addSubview: self.markLine];
    [self.markLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-4);
        make.centerX.mas_equalTo(_selectedBtn.mas_centerX);
    }];
    
    
    
}

- (void)buttonTouchEvent:(MEBaseButton *)sender {
    
    
    if (sender.tag != _selectedBtn.tag) {
        _selectedBtn = sender;
        if (self.babyPhotoHeaderCallBack) {
            self.babyPhotoHeaderCallBack(sender.tag - 100);
        }
    }
    [self updateMarkLineConstraints: sender.tag - 100];
}

- (void)updateMarkLineConstraints:(NSInteger)page {
    //page == sender.tag - 100
    
    [self setNeedsUpdateConstraints];
    
    MEBaseButton *btn = [self viewWithTag: 100 + page];
    
    weakify(self);
    [UIView animateWithDuration: PBANIMATE_DURATION animations:^{
        strongify(self);
        [self.markLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.centerX);
        }];
        [self.markLine.superview layoutIfNeeded];
    }];
    
    
}

#pragma mark - lazyloading
- (MEBaseScene *)markLine {
    if (!_markLine) {
        _markLine = [[MEBaseScene alloc] init];
        _markLine.backgroundColor = [UIColor blackColor];
    }
    return _markLine;
}


@end
