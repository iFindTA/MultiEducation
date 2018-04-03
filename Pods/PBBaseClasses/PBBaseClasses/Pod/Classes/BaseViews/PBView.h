//
//  PBView.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBConstant.h"

@interface PBView : UIView

/**
 placeholder view
 */
@property (nonatomic, strong, nullable, readonly) UILabel *placeholder;

/**
 whether self is visible
 
 @return reulst
 */
- (BOOL)isVisible;

/**
 wether show the placeholder view
 
 @param show :hidden or show
 @param holder :show info
 */
- (void)showPlaceholder:(BOOL)show withInfo:(NSString * _Nullable)holder;

/**
 when touch error placeholder view
 */
- (void)didTouchErrorPlaceholder NS_REQUIRES_SUPER;

@end
