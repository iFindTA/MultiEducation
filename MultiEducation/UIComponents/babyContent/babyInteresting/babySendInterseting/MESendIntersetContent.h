//
//  MESendIntersetContent.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MESendIntersetContent : MEBaseScene

@property (nonatomic, copy) void(^DidPickerButtonTouchCallback) (void);
@property (nonatomic, copy) void(^DidRemakeMasonry) (UIView *bottomView);

- (void)didSelectImagesOrVideo:(NSArray <NSDictionary *> *)images;
  
@end
