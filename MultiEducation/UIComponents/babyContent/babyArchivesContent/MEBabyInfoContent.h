//
//  MEBabyInfoContent.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class GuStudentArchivesPb;
@class MEArchivesView;
@class MEBabyInfoHeader;

@interface MEBabyInfoContent : MEBaseScene

@property (nonatomic, strong) MEBabyInfoHeader *header;

@property (nonatomic, strong) MEArchivesView *heightView;
@property (nonatomic, strong) MEArchivesView *weightView;
@property (nonatomic, strong) MEArchivesView *nickView;
@property (nonatomic, strong) MEArchivesView *nationView;
@property (nonatomic, strong) MEArchivesView *bloodView;
@property (nonatomic, strong) MEArchivesView *zodiacView;
@property (nonatomic, strong) MEArchivesView *leftEyeView;
@property (nonatomic, strong) MEArchivesView *rightEyeView;
@property (nonatomic, strong) MEArchivesView *HGBView;

@property (nonatomic, strong) MEArchivesView *addressView;

@property (nonatomic, copy) void (^didTapPortraitCallback) (void);

- (void)changeBabyPortrait:(NSString *)portrait;

- (void)setData:(GuStudentArchivesPb *)pb;


@end
