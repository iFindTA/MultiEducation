//
//  MEPersonalListModel.h
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseModel.h"
#define default_cell_height      45
#define vip_cell_height          45
#define record_cell_height       160


typedef NS_ENUM(NSUInteger, MEPersonalListModelType) {
    MEPersonalListModelTypeDefault                                 =   1   <<  0,//基础功能样式
    MEPersonalListModelTypeVip                                     =   1   <<  1,//会员
    MEPersonalListModelTypeRecord                                  =   1   <<  2,//历史记录
};

@interface MEPersonalListModel : MEBaseModel


@property (nonatomic, assign) MEPersonalListModelType cellType;
@property (nonatomic, copy)   NSString *cellTitle;
@property (nonatomic, copy)   NSString *VipTime;
@property (nonatomic, strong) NSMutableArray *recordArr;

@end
