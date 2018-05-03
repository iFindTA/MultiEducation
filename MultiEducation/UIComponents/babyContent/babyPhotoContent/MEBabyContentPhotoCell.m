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
#import "MEBabyAlbumListVM.h"

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
    [self setCoverImage: pb];
    [self setCountLabText: pb];
    if (pb.isSelectStatus) {
        self.selectBtn.hidden = NO;
    } else {
        self.selectBtn.hidden = YES;
    }
    self.selectBtn.selected = pb.isSelect;
}

- (void)setCountLabText:(ClassAlbumPb *)pb {
    if (pb.isParent) {
        self.countLab.hidden = NO;
        NSInteger count = [MEBabyAlbumListVM fetchAlbumsWithParentId: pb.id_p].count;
        if (count > 99) {
            self.countLab.text = @"99+";
        } else {
            self.countLab.text = [NSString stringWithFormat: @"%ld", count];
        }
    } else {
        self.countLab.hidden = YES;
    }
}

- (void)setCoverImage:(ClassAlbumPb *)pb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    if (pb.isParent) {
        self.floderNameLabel.hidden = NO;
        self.floderNameLabel.text = pb.fileName;
        NSArray *albums = [MEBabyAlbumListVM fetchAlbumsWithParentId: pb.id_p];
        if (albums.count != 0) {
            ClassAlbumPb *firstAlbumPb = albums.firstObject;
            NSString *urlStr;
            if (firstAlbumPb.isParent) {
                ClassAlbumPb *innerPb = [self getTheFirstAlbumCoverImageInFolder: firstAlbumPb.id_p];
                if ([innerPb.fileType isEqualToString: @"mp4"]) {
                    urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, innerPb.filePath, QN_VIDEO_FIRST_FPS_URL];
                } else {
                    urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, innerPb.filePath];
                }
            } else {
                if ([firstAlbumPb.fileType isEqualToString: @"mp4"]) {
                    urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
                } else {
                    urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, firstAlbumPb.filePath];
                }
            }

            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"baby_content_photo_placeholder"] options: SDWebImageRetryFailed];
        } else {
            self.photoIcon.image = [UIImage imageNamed: @"baby_content_photo_placeholder"];
        }
    } else {
        self.floderNameLabel.hidden = YES;
        self.floderNameLabel.text = @"";
        if ([pb.fileType isEqualToString: @"mp4"]) {
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"baby_content_photo_placeholder"] options: SDWebImageRetryFailed];
        } else {
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, pb.filePath];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"baby_content_photo_placeholder"] options: SDWebImageRetryFailed];
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

//when the folderA in folderB, get the folderA's coverImage to give folderB, and maybe floderC in floderA, so this is a recurrence func
- (ClassAlbumPb *)getTheFirstAlbumCoverImageInFolder:(int64_t)parentId {
    ClassAlbumPb *pb = [MEBabyAlbumListVM fetchAlbumsWithParentId: parentId].firstObject;
    if (pb) {
        if (pb.isParent) {
            return [self getTheFirstAlbumCoverImageInFolder: pb.parentId];
        } else {
            return pb;
        }
    } else {
        return nil;
    }
}


@end
