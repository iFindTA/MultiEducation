//
//  MEBaseImageView.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/12.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseImageView.h"

@implementation MEBaseImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
