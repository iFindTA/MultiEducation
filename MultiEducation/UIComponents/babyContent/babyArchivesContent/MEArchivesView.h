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


/**
 文字内容
 */
@property (nonatomic, strong) NSString *title;

/**
 提示输入文字
 */
@property (nonatomic, strong) NSString *tip;

/**
 是否需要增减标志view
 */
@property (nonatomic, assign) MEArchivesType type;

/**
 增减数字
 */
@property (nonatomic, assign) double count;

/**
 是否需要限制只能输入数字
 */
@property (nonatomic, assign) BOOL isOnlyNumber;


/**
 文字color
 */
@property (nonatomic, strong) UIColor *titleTextColor;

/**
 提示文字颜色
 */
@property (nonatomic, strong) UIColor *tipTextColor;

@property (nonatomic, copy) void(^didTapArchivesViewCallback) (void);

//是否需要开启内部编辑手势，如果true，则进行lab与textField的切换，反之实现callback
- (void)configArchives:(BOOL)whetherNeedGes;

//通过DatePicker 或者 AlertController 选择后修改titleText
- (void)changeTitle:(NSString *)titleText;

//修改placeholder;
- (void)setPlaceHolder:(NSString *)placeholder;

//修改tip文字
- (void)changeTip:(NSString *)tipText;

//修改增减数字
- (void)changeCount:(double)count;

@end
