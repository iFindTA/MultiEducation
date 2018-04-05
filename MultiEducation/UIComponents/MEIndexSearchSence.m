//
//  MEIndexSearchSence.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexSearchSence.h"

@interface MEIndexSearchSence ()

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) MESearchBlock retBlock;

@end

@implementation MEIndexSearchSence

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelEventTrigger) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

- (void)handleSearchBlock:(MESearchBlock)block {
    self.retBlock = [block copy];
}

- (void)cancelEventTrigger {
    self.retBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
