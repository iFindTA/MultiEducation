//
//  METimeLineSectionView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METimeLineSectionView.h"
#import <Masonry.h>

@implementation METimeLineSectionView
  
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _label = [[MEBaseLabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.font = UIFontPingFangSC(18);
        _label.textAlignment = NSTextAlignmentLeft;
        [self addSubview: self.label];
        //layout
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}



@end
