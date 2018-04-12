//
//  MEIndexSearchMaskScene.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexSearchMaskScene.h"

@implementation MEIndexSearchMaskScene

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
        label.text = @"热门搜索";
        [self addSubview:label];
        
        //self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)userDidTouchKeyword:(NSString *)key {
    //TODO://更新历史
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
