//
//  MESideHideenMenu.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESideHideenMenu.h"
#import "UIView+ClipsCornerRadius.h"

@interface MESideHideenMenu ()

@property (nonatomic, copy) void(^hideMenuHandler)(void);

@end

@implementation MESideHideenMenu

- (instancetype)initWithHandler:(void (^)(void))handler {
    self = [super init];
    if (self) {
        self.hideMenuHandler = handler;
        self.backgroundColor = [UIColor clearColor];
        
        MEBaseLabel *menuLab = [[MEBaseLabel alloc] init];
        menuLab.backgroundColor = [UIColor whiteColor];
        menuLab.text = @"操作列表";
        menuLab.textAlignment = NSTextAlignmentCenter;
        menuLab.numberOfLines = 4;
        menuLab.textColor = UIColorFromRGB(0x999999);
        menuLab.font = UIFontPingFangSC(14);
        menuLab.userInteractionEnabled = YES;
        [self addSubview: menuLab];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hideMenuTapEvent)];
        [menuLab addGestureRecognizer: tapGes];
        
        //layout
        [menuLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.width.mas_equalTo(26.f);
            make.height.mas_equalTo(100.f);
        }];
        
        [menuLab.superview layoutIfNeeded];
        [menuLab clipsCorner: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(3.f, 3.f)];
        
    }
    return self;
}

- (void)hideMenuTapEvent {
    
    if (self.hideMenuHandler) {
        self.hideMenuHandler();
    }
    
    
}
@end
