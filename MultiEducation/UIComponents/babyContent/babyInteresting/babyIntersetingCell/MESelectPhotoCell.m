//
//  MESelectPhotoCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESelectPhotoCell.h"

@interface MESelectPhotoCell () {
    NSDictionary *_dic;
}

@end

@implementation MESelectPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _photo.contentMode = UIViewContentModeScaleAspectFill;
    _photo.clipsToBounds = true;
}

- (void)setPhotoCell:(NSDictionary *)dic {
    _dic = dic;
    
    UIImage *image;
    if ([[dic objectForKey: @"extension"] isEqualToString: @"mp4"]) {
        image = [UIImage imageWithData: [dic objectForKey: @"coverImage"]];
    } else {
        image = [UIImage imageWithData: [dic objectForKey: @"data"]];
    }
    
    self.deleteBtn.hidden = false;
    self.photo.image = image;
} 

- (void)setSelectCell {
    self.deleteBtn.hidden = true;
    self.photo.image = [UIImage imageNamed: @"baby_interesting_add_image"];
} 
 
- (IBAction)didDeletePhotoTouchEvent:(MEBaseButton *)sender {
    if (self.DidDeleteCallback) {
        self.DidDeleteCallback(_dic);
    }
}

@end
