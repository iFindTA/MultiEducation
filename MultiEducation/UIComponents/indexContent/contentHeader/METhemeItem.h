//
//  METhemeItem.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

/**
 1:方形 2:圆形 3:左右
 */
typedef NS_ENUM(int32_t, METhemeLayout) {
    METhemeLayoutRect = 1,
    METhemeLayoutCircle = 2,
    METhemeLayoutLandscape = 3,
};

@interface METhemeItem : MEBaseScene

/**
 item title
*/
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) MEBaseLabel *label;

/**
 item uri
 */
@property (nonatomic, copy) NSString * uri;
@property (nonatomic, strong, readonly) UIImageView *icon;

/**
 layout type
 */
@property (nonatomic, assign, readonly) METhemeLayout type;

/**
 item callback
 */
@property (nonatomic, copy) void(^callback)(NSUInteger tag);

- (id)initWithType:(METhemeLayout)type;

- (void)configureItemSubviews NS_REQUIRES_SUPER;

@end
