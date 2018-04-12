//
// Created by laborc on 16/5/25.
// Copyright (c) 2016 laborc. All rights reserved.
//

#import "UIView+Utils.h"


@implementation UIView (Utils)
- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }

        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}
@end
