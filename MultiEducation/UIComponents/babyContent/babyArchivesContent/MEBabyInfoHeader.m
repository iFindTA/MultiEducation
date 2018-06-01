//
//  MEBabyInfoHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInfoHeader.h"

@interface MEBabyInfoHeader()
@property (nonatomic, strong) MEBaseImageView *backImage;

@end

@implementation MEBabyInfoHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.backImage];
        //layout
        [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - lazyloading
- (MEBaseImageView *)backImage {
    if (!_backImage) {
        _backImage = [[MEBaseImageView alloc] initWithFrame: CGRectZero];
        _backImage.image = [UIImage imageNamed: @"baby_archives_baby_info_backimage"];
    }
    return _backImage;
}


@end
