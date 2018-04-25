//
//  MESideHideenMenu.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESideHideenMenu.h"
#import "UIView+ClipsCornerRadius.h"

@implementation MESideHideenMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubviews];
    }
    return self;
}

- (void)customSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    MEBaseLabel *menuLab = [[MEBaseLabel alloc] init];
    menuLab.backgroundColor = [UIColor whiteColor];
    menuLab.text = @"操作列表";
    menuLab.textAlignment = NSTextAlignmentCenter;
    menuLab.numberOfLines = 4;
    menuLab.textColor = UIColorFromRGB(0x999999);
    menuLab.font = UIFontPingFangSC(12);
    [self addSubview: menuLab];
    
    //layout
    [menuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [menuLab.superview layoutIfNeeded];
    [menuLab clipsCorner: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(3.f, 3.f)];
}


@end
