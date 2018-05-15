//
//  METhemeItem.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

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
 1:方形 2:圆形 3:左右
 */
@property (nonatomic, copy, readonly) NSString *type;

/**
 item callback
 */
@property (nonatomic, copy) void(^callback)(NSUInteger tag);

- (id)initWithType:(NSString *)type;

- (void)configureItemSubviews NS_REQUIRES_SUPER;

@end
