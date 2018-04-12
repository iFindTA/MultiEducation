//
//  MEProgressView.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEProgressView : UIView

@property (assign, nonatomic) CGFloat progress;//当前进度
@property (strong, nonatomic) UIColor *progressBgColor;//进度条背景颜色
@property (strong, nonatomic) UIColor *progressColor;//进度条颜色
@property (assign, nonatomic) CGFloat loadProgress;//加载好的进度
@property (strong, nonatomic) UIColor *loadProgressColor;//已经加载好的进度颜色

@end
