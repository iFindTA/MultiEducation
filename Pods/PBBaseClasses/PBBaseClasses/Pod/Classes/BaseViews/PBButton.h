//
//  PBButton.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBButton : UIButton

/**
 factory class method to create a button
 
 @param buttonType as system
 @return the button
 */
+ (instancetype)buttonWithType:(UIButtonType)buttonType;

@end
