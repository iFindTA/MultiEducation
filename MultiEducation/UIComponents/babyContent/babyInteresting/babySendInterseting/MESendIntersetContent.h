//
//  MESendIntersetContent.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class MEBabyIntersetingSelectView;
@class MEStudentModel;
@class MEStuInterestModel;

@interface MESendIntersetContent : MEBaseScene

@property (nonatomic, assign) int64_t semester;
@property (nonatomic, assign) int64_t classId;
@property (nonatomic, assign) int64_t gradeId;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *selectedImages;   //当前选中的image
@property (nonatomic, copy) void(^DidPickerButtonTouchCallback) (void);
@property (nonatomic, copy) void(^didFetchlocalizationDataHandler) (MEStuInterestModel *model);


- (void)didSelectImagesOrVideo:(NSArray <NSDictionary *> *)images;

- (NSArray <MEStudentModel *> *)getInterestingStuArr;

- (void)customSubviews;

//获取趣事趣影标题
- (NSString *)getInterestTitle;
//获取趣事趣影内容
- (NSString *)getInterestContext;


/**
 根据是否有缓存数据决定是否显示alert
 */
- (void)showAlert2UserWhetherFetchStuInterestModel;

@end
