//
//  MEVideoPreview.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@protocol MEVideoPreviewDelegate;
@interface MEVideoPreview : MEBaseScene

@property (nonatomic, weak) id <MEVideoPreviewDelegate> delegate;

- (void)autoPlayWithVideoPath:(NSString *)path;

- (void)autoPlay;

- (void)resetVideoPreview;

@end

@protocol MEVideoPreviewDelegate <NSObject>
@optional
- (void)didTouchRecallWithPreview:(MEVideoPreview *)preview;
- (void)didTouchEnsureWithPreview:(MEVideoPreview *)preview;
@end;
