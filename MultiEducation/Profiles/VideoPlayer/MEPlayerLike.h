//
//  MEPlayerLike.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEPlayerLike : MEBaseScene

@property (nonatomic, strong) IBOutlet UIImageView *icon;
@property (nonatomic, strong) IBOutlet UILabel *titleLab;

@property (nonatomic, weak) IBOutlet UIButton *likeBtn;
@property (nonatomic, weak) IBOutlet UIButton *dislikeBtn;
@property (nonatomic, weak) IBOutlet UILabel *likeLab;
@property (nonatomic, weak) IBOutlet UILabel *dislikeLab;

@end
