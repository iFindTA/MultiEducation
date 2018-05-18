//
//  MESelectPhotoCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"

@interface MESelectPhotoCell : MEBaseCollectionCell

@property (weak, nonatomic) IBOutlet MEBaseImageView *photo;

@property (weak, nonatomic) IBOutlet MEBaseButton *deleteBtn;

@property (nonatomic, copy) void (^DidDeleteCallback) (NSDictionary *dic);

- (void)setSelectCell;
- (void)setPhotoCell:(NSDictionary *)dic;

@end
