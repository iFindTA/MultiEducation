//
//  MESearchBar.m
//  fsc-ios-wan
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MESearchBar.h"

@implementation MESearchBar

- (void)awakeFromNib {
    [super awakeFromNib];
    UIColor *color = [UIColor colorWithWhite:0.85 alpha:1.f];
    UIImage *img = [UIImage imageNamed:@"search_bar_magnifier"];
    img = [img pb_darkColor:color lightLevel:1.f];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    UITextField *searchTextField  = [self valueForKey:@"_searchField"];
    searchTextField.leftView = imgView;
    searchTextField.font = [UIFont systemFontOfSize:13];
    [searchTextField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)changePlaceholder2Left:(NSString *)placeholder {
    self.placeholder = placeholder;
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
