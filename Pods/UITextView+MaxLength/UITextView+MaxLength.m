//
//  UITextView+MaxLength.m
//  OLE
//
//  Created by litelin on 16/2/3.
//  Copyright © 2016年 litelin. All rights reserved.
//

#import "UITextView+MaxLength.h"
#import <objc/runtime.h>
#import "UITextView+APSUIControlTargetAction.h"

static const void *MaxLength = &MaxLength;

@implementation UITextView (MaxLength)
@dynamic maxLength;

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, MaxLength) integerValue];
}

- (void)setMaxLength:(NSInteger)maxLength {
    NSNumber *number = [[NSNumber alloc]initWithInteger:maxLength];
    objc_setAssociatedObject(self, MaxLength, number, OBJC_ASSOCIATION_COPY);
    
    [self addTarget:self action:@selector(textViewDidChange1:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textViewDidChange1:(UITextView *)sender {
    bool isChinese;//判断当前输入法是否是中文
    
    if([[self.textInputMode primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else {
        isChinese = true;
    }
    
    if(sender == self) {
        NSString *str = [[self text] stringByReplacingOccurrencesOfString:@"?"withString:@""];
        if(isChinese) {
            //中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if( str.length>= [self maxLength] + 1) {
                    NSString *strNew = [NSString stringWithString:str];
                    [self setText:[strNew substringToIndex:[self maxLength]]];
                }
            }
        }
        else {
            if([str length]>=[self maxLength] + 1) {
                NSString *strNew = [NSString stringWithString:str];
                [self setText:[strNew substringToIndex:[self maxLength]]];
            }
        }
    }
}

@end
