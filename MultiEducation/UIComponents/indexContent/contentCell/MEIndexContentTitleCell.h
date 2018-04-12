//
//  MEIndexContentTitleCell.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/12.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEIndexContentTitleCell : MEBaseCell

@property (nonatomic, strong) IBOutlet MEBaseLabel *titleLab;

@property (nonatomic, strong) IBOutlet MEBaseScene *leftScene;
@property (nonatomic, strong) IBOutlet MEBaseLabel *leftTitleLab;
@property (nonatomic, strong) IBOutlet MEBaseImageView *leftImageView;

@property (nonatomic, strong) IBOutlet MEBaseScene *rightScene;
@property (nonatomic, strong) IBOutlet MEBaseLabel *rightTitleLab;
@property (nonatomic, strong) IBOutlet MEBaseImageView *rightImageView;

/**
 故事点击回调
 */
@property (nonatomic, copy) void (^MEIndexItemCallback)(NSUInteger section, NSUInteger index);

@end
