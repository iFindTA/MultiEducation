//
//  UIImageView+MEVideo.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "UIImageView+MEVideo.h"
#import <SDWebImage/SDImageCache.h>


@implementation UIImageView (MEVideo)

- (void)pb_setVideoURL:(NSURL *)url placehodler:(UIImage *)placeholder {
    if (!url) {
        [self setImage:placeholder];
        return;
    }
    
}

@end
