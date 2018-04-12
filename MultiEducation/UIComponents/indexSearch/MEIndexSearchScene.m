//
//  MEIndexSearchScene.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexSearchScene.h"
#import "MESearchBar.h"
#import "MEIndexSearchBar.h"
#import "MEIndexSearchMaskScene.h"

@interface MEIndexSearchScene () <MEIndexSearchBarDelegate>

@property (nonatomic, strong) MEIndexSearchMaskScene *maskScene;

@property (nonatomic, strong) NSMutableArray *dataSource;//应该放在ViewModel
@property (nonatomic, strong) UITableView *table;

@end

@implementation MEIndexSearchScene

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.table];
        [self addSubview:self.maskScene];
        self.maskScene.callback = ^(NSString *key){
            NSLog(@"点击关键字:%@", key);
        };
        //self.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.maskScene makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

#pragma mark --- lazy load

- (MEIndexSearchMaskScene *)maskScene {
    if (!_maskScene) {
        _maskScene = [[MEIndexSearchMaskScene alloc] initWithFrame:CGRectZero];
        //_table.tableFooterView = [UIView new];
    }
    return _maskScene;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _table;
}

- (void)resetSearchState {
    [self.dataSource removeAllObjects];
    [self.table reloadData];
    self.maskScene.hidden = false;
}

#pragma mark --- touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[super touchesBegan:touches withEvent:event];
    [self.searchBar passive2ResignFirsetResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
