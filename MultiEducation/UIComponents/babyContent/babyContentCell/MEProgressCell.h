//
//  MEProgressCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
#import "MEVideo.h"

@interface MEProgressCell : MEBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet MEBaseLabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet MEBaseLabel *retryLabel;



@end
