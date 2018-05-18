//
//  Card.h
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//  被切换的卡片

#import <UIKit/UIKit.h>
 
@interface CardCell : UICollectionViewCell
 
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIView *countLab;
@property (weak, nonatomic) IBOutlet UIView *titleLab;
@property (weak, nonatomic) IBOutlet UIView *subTitleLab;
@property (weak, nonatomic) IBOutlet UIView *remarkLab;

@end
