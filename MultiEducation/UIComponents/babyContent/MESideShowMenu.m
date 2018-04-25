//
//  MESideShowMenu.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESideShowMenu.h"
#import "MEMenuButton.h"
#import "UIView+ClipsCornerRadius.h"

static CGFloat const BTN_WIDTH = 35.f;
static CGFloat const BTN_HEIGHT = 56.f;

@interface MESideShowMenu ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) MEMenuButton *uploadBtn;
@property (nonatomic, strong) MEMenuButton *createBtn;
@property (nonatomic, strong) MEMenuButton *moveBtn;
@property (nonatomic, strong) MEMenuButton *deleteBtn;

@property (nonatomic, copy) void((^touchHandler)(MEUserTouchEventType type));

@end

@implementation MESideShowMenu

- (instancetype)initWitHandler:(void(^)(MEUserTouchEventType type))handler {
    self = [super init];
    if (self) {
        self.touchHandler = handler;
        [self addSubview: self.backView];
        [self.backView addSubview: self.uploadBtn];
        [self.backView addSubview: self.createBtn];
        [self.backView addSubview: self.moveBtn];
        [self.backView addSubview: self.deleteBtn];
        
        CGFloat toLeft = (54.f - BTN_WIDTH) / 2;
        //layout
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.width.mas_equalTo(54.f);
            make.height.mas_equalTo(305.f);
        }];
        [self.backView.superview  layoutIfNeeded];
        [self.backView clipsCorner: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(3.f, 3.f)];
        
        [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(10.f);
            make.width.mas_equalTo(BTN_WIDTH);
            make.height.mas_equalTo(BTN_HEIGHT);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(toLeft);
        }];
        
        [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.uploadBtn.mas_bottom).mas_offset(15.f);
            make.width.mas_equalTo(BTN_WIDTH);
            make.height.mas_equalTo(BTN_HEIGHT);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(toLeft);
        }];
        
        [self.moveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.createBtn.mas_bottom).mas_offset(15.f);
            make.width.mas_equalTo(BTN_WIDTH);
            make.height.mas_equalTo(BTN_HEIGHT);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(toLeft);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moveBtn.mas_bottom).mas_offset(15.f);
            make.width.mas_equalTo(BTN_WIDTH);
            make.height.mas_equalTo(BTN_HEIGHT);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(toLeft);
        }];
        
    }
    return self;
}

#pragma mark - lazyloading
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (MEMenuButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [[MEMenuButton alloc] initWithTouchHandler:^{
            self.touchHandler(MEUserTouchEventTypeUpload);
        }];
        _uploadBtn.textLab.text = @"上传";
        _uploadBtn.icon.image = [UIImage imageNamed: @"appicon_placeholder"];
        _uploadBtn.textLab.textColor = UIColorFromRGB(0x6fa4f0);
    }
    return _uploadBtn;
}

- (MEMenuButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [[MEMenuButton alloc] initWithTouchHandler:^{
            self.touchHandler(MEUserTouchEventTypeNewFolder);
        }];
        _createBtn.textLab.text = @"新建";
        _createBtn.icon.image = [UIImage imageNamed: @"appicon_placeholder"];
        _createBtn.textLab.textColor = UIColorFromRGB(0x6fa4f0);
    }
    return _createBtn;
}

- (MEMenuButton *)moveBtn {
    if (!_moveBtn) {
        _moveBtn = [[MEMenuButton alloc] initWithTouchHandler:^{
            self.touchHandler(MEUserTouchEventTypeMove);
        }];
        _moveBtn.textLab.text = @"移动";
        _moveBtn.icon.image = [UIImage imageNamed: @"appicon_placeholder"];
        _moveBtn.textLab.textColor = UIColorFromRGB(0x6fa4f0);
    }
    return _moveBtn;
}

- (MEMenuButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[MEMenuButton alloc] initWithTouchHandler:^{
            self.touchHandler(MEUserTouchEventTypeDelete);
        }];
        _deleteBtn.textLab.text = @"删除";
        _deleteBtn.icon.image = [UIImage imageNamed: @"appicon_placeholder"];
        _deleteBtn.textLab.textColor = UIColorFromRGB(0x6fa4f0);
    }
    return _deleteBtn;
}

@end
