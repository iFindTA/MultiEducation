//
//  MEEvaluatePanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@protocol MEEvaluateDelegate, MEEvaluateDataSource;
@interface MEEvaluatePanel : MEBaseScene

@property (nonatomic, weak) id<MEEvaluateDelegate> delegate;

@property (nonatomic, weak) id<MEEvaluateDataSource> dataSource;

@end

@protocol MEEvaluateDataSource <NSObject>

- (NSArray *)titleForEvaluate;

- (BOOL)editableForTitle:(NSString *)title;

@end

@protocol MEEvaluateDelegate <NSObject>

@end
