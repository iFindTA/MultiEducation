//
//  PBNavigationBar.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/22.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBNavigationBar.h"
#import "PBConstant.h"
#import <PBKits/UIDevice+PBHelper.h>

@interface PBNavigationBar ()

@property (nonatomic, assign, readwrite) CGFloat barHeight;

@end

@implementation PBNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.prefersLargeTitles = true;
    }
    return self;
}

- (CGFloat)barHeight {
    if (_barHeight == 0) {
        CGFloat statusBarHeight = PB_STATUSBAR_HEIGHT;
        if (@available(iOS 11.0, *) && [UIDevice pb_isiPhoneX]) {
            statusBarHeight = PB_STATUSBAR_HEIGHT_X;
        }
        _barHeight = PB_NAVIBAR_HEIGHT + statusBarHeight;
    }
    return _barHeight;
}

//*
- (void)layoutSubviews {
    [super layoutSubviews];
    //注意导航栏及状态栏高度适配
    CGFloat naviBarHeight = self.barHeight;
    CGFloat statusBarHeight = self.barHeight - PB_NAVIBAR_HEIGHT;
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), naviBarHeight);
    for (UIView *view in self.subviews) {
        //NSLog(@"sub class:%@", NSStringFromClass(view.class));
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        } else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGFloat offset = @available(iOS 11.0, *) ? 30: 0;
            CGRect frame = view.frame;
            frame.origin.x -= offset * 0.5;
            frame.origin.y = statusBarHeight;
            frame.size.height = self.bounds.size.height - frame.origin.y;
            frame.size.width += offset;
            view.frame = frame;
        }
    }
    
}
//*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
