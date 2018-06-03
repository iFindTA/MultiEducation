//
//  MEArchivesView.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef NS_ENUM(NSUInteger, MEArchivesType) {
    MEArchivesTypeNormal = 1                                                      <<   0,  //不带有提示增减标志
    MEArchivesTypeTipCount = 1                                                    <<   1   //带有提示增减标志
};

@interface MEArchivesView : MEBaseScene

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, assign) MEArchivesType type;
@property (nonatomic, assign) double count;

@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *tipTextColor;

@property (nonatomic, copy) void(^didTapArchivesViewCallback) (void);

//是否需要开启内部编辑手势，如果true，则进行lab与textField的切换，反之实现callback
- (void)configArchives:(BOOL)whetherNeedGes;

//通过DatePicker 或者 AlertController 选择后修改titleText
- (void)changeTitle:(NSString *)titleText;

@end