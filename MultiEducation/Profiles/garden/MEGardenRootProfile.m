//
//  MEGardenRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEGardenRootProfile.h"
#import "GardenHeader.h"
#import "UIView+Frame.h"

#define ORIGIN_HEADER_HEIGHT 250.f
#define MAX_RANGE_HEADER_DIFF (ORIGIN_HEADER_HEIGHT - ME_HEIGHT_STATUSBAR - ME_HEIGHT_NAVIGATIONBAR)

#define MIN_HEADER_HEIGHT (ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR)

@interface MEGardenRootProfile () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MEGardenHeaderDelegate> {
    CGFloat lastContentOffset;  //judge tableview scroll direction
}

@property (nonatomic, strong) GardenHeader *gardenHeader;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEGardenRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gardenHeader = [[[NSBundle mainBundle] loadNibNamed: @"GardenHeader" owner: self options: nil] firstObject];
    self.gardenHeader.delegate = self;
    
    [self.view addSubview: self.gardenHeader];
    [self.view addSubview: self.tableView];
    
    
    //layout
    __weak typeof(self) weakSelf = self;
    [self.gardenHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.view.mas_top).mas_offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(0);
        make.height.mas_equalTo(ORIGIN_HEADER_HEIGHT);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.gardenHeader.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).mas_offset(0);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableviewDidScrollWithPercent:(CGFloat)percent direction:(METableViewScrollDirection)direction {
    
    CGFloat headerHeight = ((1 - percent) * ORIGIN_HEADER_HEIGHT > MIN_HEADER_HEIGHT ? (1 - percent) * ORIGIN_HEADER_HEIGHT : MIN_HEADER_HEIGHT);
    
    [self.gardenHeader mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(headerHeight);
    }];
    
    [self.gardenHeader contentAnimationWithPercent: percent direction: direction];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"];
    }
    cell.textLabel.text = @"cell";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual: self.tableView]) {
            METableViewScrollDirection direction;
            if (scrollView.contentOffset.y < lastContentOffset) {
                //up scroll
                direction = METableViewScrollDirectionUp;
            } else {
                //down scroll
                direction = METableViewScrollDirectionDown;
            }
        
        CGFloat percent = scrollView.contentOffset.y / MAX_RANGE_HEADER_DIFF;
        
        if (percent > 1) {
            percent = 1;
        }
        if (percent < 0) {
            percent = 0;
        }
        
        [self tableviewDidScrollWithPercent: percent direction: direction];

    }
 
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

#pragma mark - MEGardenHeaderDelegate
- (void)didTouchCamera {
    NSLog(@"did touch carmera");
}

- (void)didTouchGardenHeaderType:(MEGardenHeaderType)type {
    NSLog(@"did touch garden header type: %ld", (unsigned long)type);
}

#pragma mark - lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 100.0f;
    }
    return _tableView;
}




@end
