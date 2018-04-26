//
//  MECollectionViewCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentPhotoCell.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"

@interface MEBabyContentPhotoCell ()

@property (nonatomic, strong) ClassAlbumPb *albumPb;

@end

@implementation MEBabyContentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setData:(ClassAlbumPb *)pb {
    _albumPb = pb;
    if (pb.isParent) {
        self.floderNameLabel.hidden = NO;
        self.floderNameLabel.text = pb.fileName;
        [self setCoverImage: pb];
    } else {
        self.floderNameLabel.hidden = YES;
        self.floderNameLabel.text = @"";
        [self setCoverImage: pb];
    }
    if (pb.isSelectStatus) {
        self.selectBtn.hidden = NO;
    } else {
        self.selectBtn.hidden = YES;
    }
    self.selectBtn.selected = pb.isSelect;
}

- (void)setCoverImage:(ClassAlbumPb *)pb {
    if (pb.isParent) {
        self.photoIcon.image = [UIImage imageNamed: @"baby_content_new_folder"];
    } else {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *user = delegate.curUser;
        if ([pb.fileType isEqualToString: @"mp4"]) {
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr]];
        } else {
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, pb.filePath];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr]];
        }
    }
}

- (IBAction)selectToDeleteTouchEvent:(MEBaseButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    self.albumPb.isSelect = self.selectBtn.selected;
    if (self.handler) {
        self.handler(_albumPb);
    }
}


@end
