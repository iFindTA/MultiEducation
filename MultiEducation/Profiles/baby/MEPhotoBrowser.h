//
//  MEPhotoBrowser.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface MEPhotoBrowser : MWPhotoBrowser

@property (nonatomic, copy) void(^DidBackItemHandler)(void);
@property (nonatomic, copy) void(^DidGotoBabyPhotoProfileHandler)(void);

@end
