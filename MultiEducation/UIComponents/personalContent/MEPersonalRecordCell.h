//
//  MEPersonalRecordCell.h
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseCell.h"
#import "MEPersonalListModel.h"

@interface MEPersonalRecordCell : MEBaseCell<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) MEPersonalListModel *cellModel;


@end
