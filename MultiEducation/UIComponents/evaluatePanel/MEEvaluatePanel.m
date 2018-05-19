//
//  MEEvaluatePanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEEvaluatePanel.h"

@interface MEEvaluatePanel ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation MEEvaluatePanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor pb_randomColor];
    }
    return self;
}

#pragma mark --- user interface actions

- (void)resetEvaluateContent {
    
}

- (void)didChanged2Student4ID:(int64_t)sid {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
