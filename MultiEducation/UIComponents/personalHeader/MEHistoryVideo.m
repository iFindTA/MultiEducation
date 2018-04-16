//
//  MEHistoryVideo.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEHistoryVideo.h"

#define CELL_ITEM_SIZE CGSizeMake(130.f, 72.f)

static CGFloat const HEADER_HEIGHT = 52.f;
static CGFloat const MIN_ITEM_SPACE = 5.f;
static NSString * const CELL_IDEF = @"cell_idef";

@interface MEHistoryVideo() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MEBaseScene *header;

@property (nonatomic, strong) UICollectionView *historyVideo;

@property (nonatomic, strong) NSMutableArray *videos;   //dataSource

@end

@implementation MEHistoryVideo

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview: self.header];
        [self addSubview: self.historyVideo];
        
        //layout
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.height.mas_equalTo(HEADER_HEIGHT);
        }];
        
        [self.historyVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(5.f);
            make.top.bottom.right.mas_equalTo(self);
        }];
        
        [self customHistoryVideoHeader];
        
    }
    return self;
}

- (void)customHistoryVideoHeader {
    MEBaseLabel *titleLabel = [[MEBaseLabel alloc] init];
    titleLabel.font = UIFontPingFangSC(15);
    titleLabel.text = @"历史记录";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    [self.header addSubview: titleLabel];

    UIImageView *icon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"personal_right_arrows_icon"]];
    [self.header addSubview: icon];
    
    //layout
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.header.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.header.mas_top).mas_offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 10));
        make.right.mas_equalTo(self.header).mas_offset(-10);
        make.centerY.mas_equalTo(titleLabel);
    }];
}

- (void)videoHistoryTapEvent {
    NSLog(@"did tap video history header!!!");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_IDEF forIndexPath: indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select cell at indexPath.item %ld", indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_ITEM_SIZE;
}

#pragma mark - lazyloading
- (MEBaseScene *)header {
    if (!_header) {
        _header = [[MEBaseScene alloc] init];
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(videoHistoryTapEvent)];
        [_header addGestureRecognizer: tapHeader];
    }
    return _header;
}

- (UICollectionView *)historyVideo {
    if (!_historyVideo) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = MIN_ITEM_SPACE;
        layout.minimumLineSpacing = MIN_ITEM_SPACE;
        
        _historyVideo = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _historyVideo.delegate = self;
        _historyVideo.dataSource = self;
        _historyVideo.backgroundColor = [UIColor blueColor];
        _historyVideo.showsVerticalScrollIndicator = NO;
        
        [_historyVideo registerNib: [UINib nibWithNibName: @"MEHistoryCell" bundle: nil] forCellWithReuseIdentifier:  CELL_IDEF];
    }
    return _historyVideo;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray arrayWithCapacity: 10];
    }
    return _videos;
}

@end