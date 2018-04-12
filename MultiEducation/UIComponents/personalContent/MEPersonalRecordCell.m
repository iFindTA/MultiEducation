//
//  MEPersonalRecordCell.m
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRecordCell.h"

@implementation MEPersonalRecordCell
{
    MEBaseLabel *_titleLabel;
    UICollectionView *_collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, record_cell_height)];
        contentView.backgroundColor = UIColorFromRGB(0xffffff);
        contentView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
        contentView.layer.borderWidth = .25f;
        [self.contentView addSubview:contentView];
        
        _titleLabel = [[MEBaseLabel alloc] init];
        [contentView addSubview:_titleLabel];
        _titleLabel.text = @"聊天";
        _titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((default_cell_height - METHEME_FONT_TITLE) / 2);
            make.left.mas_equalTo(10);
        }];
        
        __block MEBaseLabel *titleLabel = _titleLabel;
        UIImage *arrowImage = [UIImage imageNamed:@"personal_right_arrows_icon"];
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = arrowImage;
        [contentView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel.centerY);
            make.right.equalTo(contentView.right).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(arrowImage.size.width, arrowImage.size.height));
        }];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [flowLayout setItemSize:CGSizeMake(130, 72)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull  collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor grayColor];
        [contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(5);
            make.top.mas_equalTo(default_cell_height);
            make.bottom.equalTo(contentView.bottom).with.offset(-5);
        }];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    
    return self;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [itemView setNeedsLayout];
//    itemView.imageName = self.imageArr[indexPath.item];
    
    return itemView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *itemView = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    _currentIndex = [self.imageArr indexOfObject:itemView.imageName];
//    [self jxy_setCurrentIndex:_currentIndex];
}


- (void)setCellModel:(MEPersonalListModel *)cellModel {
    _titleLabel.text = cellModel.cellTitle;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
