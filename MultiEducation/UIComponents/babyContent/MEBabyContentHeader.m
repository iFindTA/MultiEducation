//
//  MEBabyContentHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentHeader.h"

@implementation MEBabyContentHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self addTapGesture];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(babyContentHeaderTapEvent)];
    [self addGestureRecognizer: tapGes];
}

- (void)babyContentHeaderTapEvent {
    
}



@end
