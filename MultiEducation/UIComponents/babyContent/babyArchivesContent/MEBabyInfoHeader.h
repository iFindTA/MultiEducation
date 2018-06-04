//
//  MEBabyInfoHeader.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class MEArchivesView;

@interface MEBabyInfoHeader : MEBaseScene

@property (nonatomic, strong) MEBaseImageView *backImageView;

@property (nonatomic, strong) MEArchivesView *genderView;

@property (nonatomic, strong) MEBaseImageView *portrait;

@property (nonatomic, strong) MEArchivesView *birthView;

@property (nonatomic, strong) MEArchivesView *nameView;

@property (nonatomic, copy) void (^didTapPortraitCallback) (void);

- (void)changeBabyPortrait:(NSString *)portrait;

@end
