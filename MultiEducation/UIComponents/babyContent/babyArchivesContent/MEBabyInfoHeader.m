//
//  MEBabyInfoHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInfoHeader.h"
#import "MEArchivesView.h"

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
        
        
        [self addSubview: self.genderView];
        
        [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
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

- (MEArchivesView *)genderView {
    if (!_genderView) {
        _genderView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _genderView.title = @"男";
        _genderView.tip = @"性别";
        _genderView.titleTextColor = [UIColor whiteColor];
        _genderView.tipTextColor = [UIColor whiteColor];
        _genderView.type = MEArchivesTypeNormal;
        [_genderView configArchives: false];
        _genderView.didTapArchivesViewCallback = ^{
            
        };
    }
    return _genderView;
}


@end
