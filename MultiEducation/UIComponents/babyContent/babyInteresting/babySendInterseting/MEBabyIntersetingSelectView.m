//
//  MEBabyIntersetingSelectView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyIntersetingSelectView.h"
#import "MEBabyPortraitCell.h"

#define CELL_SIZE CGSizeMake(24, 24)
#define CELL_IDEF @"cell_idef"

@interface MEBabyIntersetingSelectView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MEBaseScene *topSepView;
@property (nonatomic, strong) MEBaseScene *bottomSepView;
@property (nonatomic, strong) MEBaseLabel *tipLab;
@property (nonatomic, strong) MEBaseImageView *arrow;

@property (nonatomic, strong) UICollectionView *iconView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MEBabyIntersetingSelectView


- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapSelectBabyView)];
        [self addGestureRecognizer: tapGes];
    }
    return self;
}

- (void)didTapSelectBabyView {
    NSLog(@"didTapSelectBabyView");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MEBabyPortraitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_IDEF forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_SIZE;
}

#pragma mark - lazyloading
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UICollectionView *)iconView {
    if (!_iconView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 6.f;
        layout.minimumLineSpacing = 10.f;
        
        _iconView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _iconView.delegate = self;
        _iconView.dataSource = self;
        _iconView.backgroundColor = [UIColor whiteColor];
    }
    return _iconView;
}

- (MEBaseScene *)topSepView {
    if (!_topSepView) {
        _topSepView = [[MEBaseScene alloc] init];
        _topSepView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    }
    return _topSepView;
}

- (MEBaseScene *)bottomSepView {
    if (!_bottomSepView) {
        _bottomSepView = [[MEBaseScene alloc] init];
        _bottomSepView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    }
    return _bottomSepView;
}

- (MEBaseLabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[MEBaseLabel alloc] init];
        _tipLab.text = @"发送给谁";
        _tipLab.font = UIFontPingFangSC(16);
        _tipLab.textColor = UIColorFromRGB(0x333333);
    }
    return _tipLab;
}

- (MEBaseImageView *)arrow {
    if (!_arrow) {
        _arrow = [[MEBaseImageView alloc] initWithImage: [UIImage imageNamed: @"baby_content_arrow"]];
    }
    return _arrow;
}

@end
