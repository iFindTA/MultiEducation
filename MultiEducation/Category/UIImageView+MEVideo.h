//
//  UIImageView+MEVideo.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MEVideo)

/**
 set video url

 @param url for video
 @param placeholder for video
 */
- (void)pb_setVideoURL:(NSURL *)url placehodler:(UIImage *)placeholder;

@end
