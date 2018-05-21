//
//  MEBabyIntersetingSelectView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyIntersetingSelectView.h"
#import "MEBabyPortraitCell.h"

#define MIN_ITEM_GAP 6.f
#define MIN_LINE_GAP 6.f
#define CELL_SIZE CGSizeMake(24, 24)
#define CELL_IDEF @"cell_idef"

#define ICON_VIEW_HEIGH CELL_SIZE.height * ceil((float)self.dataArr.count / 5) + (self.dataArr.count / 5) * MIN_LINE_GAP
#define ICON_VIEW_WIDTH 144.f
static CGFloat const LEFT_SPACE = 25.f;

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
        
        [self addSubview: self.topSepView];
        [self addSubview: self.bottomSepView];
        [self addSubview: self.tipLab];
        [self addSubview: self.arrow];
        [self addSubview: self.iconView];
        
        //layout
        [self.topSepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(LEFT_SPACE);
            make.right.mas_equalTo(self).mas_offset(-LEFT_SPACE);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(ME_LAYOUT_LINE_HEIGHT);
        }];
        
        [self.bottomSepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(LEFT_SPACE);
            make.right.mas_equalTo(self).mas_offset(-LEFT_SPACE);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(ME_LAYOUT_LINE_HEIGHT);
        }];
        
        [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.topSepView.mas_leading);
            make.top.mas_equalTo(self.topSepView.mas_bottom);
            make.bottom.mas_equalTo(self.bottomSepView.mas_top);
            make.width.mas_equalTo(70.f);
        }];
        
        [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(-LEFT_SPACE);
            make.width.mas_equalTo(5.f);
            make.height.mas_equalTo(12.f);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrow.mas_left).mas_offset(-12.f);
            make.height.mas_equalTo(ICON_VIEW_HEIGH);
            make.width.mas_equalTo(ICON_VIEW_WIDTH);
            make.top.mas_equalTo(self.topSepView.mas_bottom).mas_offset(13.f);
        }];
        
        if (self.DidRemakeMasonry) {
            self.DidRemakeMasonry(self.bottomSepView);
        }
    }
    return self;
}

- (void)updateLayout {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_left).mas_offset(-12.f);
        make.height.mas_equalTo(ICON_VIEW_HEIGH);
        make.width.mas_equalTo(ICON_VIEW_WIDTH);
        make.top.mas_equalTo(self.topSepView.mas_bottom).mas_offset(13.f);
    }];
    
    [self.tipLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.topSepView.mas_leading);
        make.height.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.iconView);
        make.width.mas_equalTo(70.f);
    }];
    
    [self.bottomSepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(LEFT_SPACE);
        make.right.mas_equalTo(self).mas_offset(-LEFT_SPACE);
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(13.f);
        make.height.mas_equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    
    [self.arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-LEFT_SPACE);
        make.width.mas_equalTo(5.f);
        make.height.mas_equalTo(12.f);
        make.centerY.mas_equalTo(self.iconView);
    }];
    
    if (self.DidRemakeMasonry) {
        self.DidRemakeMasonry(self.bottomSepView);
    }
}

- (void)didTapSelectBabyView {
    NSLog(@"didTapSelectBabyView");
    weakify(self);
    void (^didSelectStuCallback) (NSArray *arr) = ^(NSArray *stuArr) {
        strongify(self);
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray: stuArr];
        [self updateLayout];
        [self.iconView reloadData];
    };
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK: didSelectStuCallback};
    NSString *urlStr = @"profile://MEMultiSelectBabyProfile";
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];

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
//        for (int i = 0; i < 51; i++) {
//            [_dataArr addObject: @1];
//        }
    }
    return _dataArr;
}

- (UICollectionView *)iconView {
    if (!_iconView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = MIN_ITEM_GAP;
        layout.minimumLineSpacing = MIN_LINE_GAP;
        
        _iconView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _iconView.delegate = self;
        _iconView.dataSource = self;
        _iconView.backgroundColor = [UIColor whiteColor];
        
        [_iconView registerNib: [UINib nibWithNibName: @"MEBabyPortraitCell" bundle: nil] forCellWithReuseIdentifier: CELL_IDEF];
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
