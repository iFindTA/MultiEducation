//
//  MEBaseTableView.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseTableView.h"

@implementation MEBaseTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
