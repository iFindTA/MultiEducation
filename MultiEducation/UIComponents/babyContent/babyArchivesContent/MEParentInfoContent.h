//
//  MEParentInfoContent.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class GuStudentArchivesPb;
@class MEParentsInfoView;

@interface MEParentInfoContent : MEBaseScene

@property (nonatomic, strong) MEParentsInfoView *dadView;
@property (nonatomic, strong) MEParentsInfoView *momView;

@property (nonatomic, strong) UITextView *tipTextView;

- (void)setData:(GuStudentArchivesPb *)pb;

FOUNDATION_EXPORT NSString * const WARN_ITEM_DEFAULT_PLACEHOLDER;

@end
