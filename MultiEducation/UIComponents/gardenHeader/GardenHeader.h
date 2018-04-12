//
//  GardenHeader.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEGardenRootProfile.h"

/**
 类型定义
 */
typedef NS_ENUM(NSUInteger, MEGardenHeaderType) {
    MEGardenHeaderTypeAnnounce                                    =   1   <<  0,//园所公告
    MEGardenHeaderTypeSurvey                                      =   1   <<  1,//问卷调查
    MEGardenHeaderTypeRecipes                                     =   1   <<  2,//每周食谱
    MEGardenHeaderTypeLive                                        =   1   <<  3,//直播课堂
};

@protocol MEGardenHeaderDelegate <NSObject>
@optional

- (void)didTouchGardenHeaderType:(MEGardenHeaderType)type;

- (void)didTouchCamera;

@end


@interface GardenHeader : MEBaseScene

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet MEBaseLabel *gardenLab;

@property (weak, nonatomic) IBOutlet UIView *contentBackView;

@property (weak, nonatomic) IBOutlet MEBaseButton *cameraBtn;

@property (weak, nonatomic) IBOutlet MEBaseButton *gardenAnnounceBtn;

@property (weak, nonatomic) IBOutlet MEBaseButton *surveyBtn;

@property (weak, nonatomic) IBOutlet MEBaseButton *recipesBtn;

@property (weak, nonatomic) IBOutlet MEBaseButton *classLiveBtn;

@property (nonatomic, weak) id <MEGardenHeaderDelegate> delegate;

- (void)contentAnimationWithPercent:(CGFloat)percent direction:(METableViewScrollDirection)direction;

@end
