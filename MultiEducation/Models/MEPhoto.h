//
//  MEPhoto.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoBrowser.h>

@interface MEPhoto : NSObject

@property (nonatomic, strong) MWPhoto *photo;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIImage *image;

@end
