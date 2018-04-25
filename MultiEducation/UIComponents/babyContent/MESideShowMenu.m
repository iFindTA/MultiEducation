//
//  MESideShowMenu.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESideShowMenu.h"
#import "MEMenuButton.h"

static CGFloat const BTN_WIDTH = 35.f;
static CGFloat const BTN_HEIGHT = 56.f;


@interface MESideShowMenu ()

@property (nonatomic, strong) MEMenuButton *uploadBtn;
@property (nonatomic, strong) MEMenuButton *createBtn;
@property (nonatomic, strong) MEMenuButton *moveBtn;
@property (nonatomic, strong) MEMenuButton *deleteBtn;


@end

@implementation MESideShowMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - lazyloading
- (MEMenuButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [[MEMenuButton alloc] initWithFrame: CGRectZero];
        _uploadBtn.textLab.text = @"上传";
        _uploadBtn.icon.image = [UIImage imageNamed: @"appicon_placeholder"];
        _uploadBtn.textLab.textColor = UIColorFromRGB(0x6fa4f0);
        
    }
    return _uploadBtn;
}


@end
