//
//  MEIndexStoryItemCell.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"

@interface MEIndexStoryItemCell : MEBaseCell

@property (nonatomic, strong) UILabel *sectionTitleLab;

@property (nonatomic, strong) MEBaseScene *marginScene;
@property (nonatomic, strong) MEBaseScene *middleSeperator;

/**
 left
 */
@property (nonatomic, strong) MEBaseScene *leftItemScene;
@property (nonatomic, strong) MEBaseImageView *leftItemImage;
@property (nonatomic, strong) MEBaseLabel *leftItemLabel;

/**
 right
 */
@property (nonatomic, strong) MEBaseScene *rightItemScene;
@property (nonatomic, strong) MEBaseImageView *rightItemImage;
@property (nonatomic, strong) MEBaseLabel *rightItemLabel;

@property (nonatomic, copy) void(^indexContentItemCallback)(NSUInteger sect, NSUInteger row);

/**
 update ui
 */
- (void)configureStoryItem4RowIndex:(NSUInteger)row;

@end
