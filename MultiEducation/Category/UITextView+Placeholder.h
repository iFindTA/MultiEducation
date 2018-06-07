//
//  UITextView+Placeholder.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)


/**
 add placeholderLabel for textView, bug when iOSVersion < 11, no effert

 @param placeholdStr string
 @param placeholdColor color
 */
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor API_AVAILABLE(ios(11));
 
@end
 
