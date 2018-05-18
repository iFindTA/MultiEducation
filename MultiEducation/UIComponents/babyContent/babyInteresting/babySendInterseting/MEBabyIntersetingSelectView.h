//
//  MEBabyIntersetingSelectView.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEBabyIntersetingSelectView : MEBaseScene

@property (nonatomic, weak) void(^DidTapBabySelectViewHandler) (void);

- (void)setData:(NSArray *)babyIconArr ;

@end
