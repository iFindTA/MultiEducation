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

@interface MEBabyContentPhotoCell () {
    CAGradientLayer *_gradientLayer;
}

@property (nonatomic, strong) ClassAlbumPb *albumPb;

@end

@implementation MEBabyContentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.playIcon.hidden = true;
    
    self.photoIcon.userInteractionEnabled = true;
    self.playIcon.userInteractionEnabled = true;
    self.floderNameLabel.userInteractionEnabled = true;
    self.countLab.userInteractionEnabled = true;
    
    [self.nameBackView layoutIfNeeded];
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.opacity = 0.5;
    layer.colors = @[(id)UIColorFromRGB(0x999999).CGColor, (id)UIColorFromRGB(0x333333).CGColor];
    layer.locations = @[@(0), @(0.5), @(1)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    _gradientLayer = layer;
    [self.nameBackView.layer addSublayer: layer];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressEvent:)];
    [self addGestureRecognizer: longPressGes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.nameBackView.bounds;
}

- (void)longPressEvent:(UIGestureRecognizer *)ges {
    if (self.renameFolderCallback) {
        self.renameFolderCallback(self.albumPb);
    }
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
            self.countLab.text = [NSString stringWithFormat: @"%ld张", count];
        }
    } else {
        self.countLab.hidden = YES;
    }
}

- (UIImage *)getPlaceHolderImage:(ClassAlbumPb *)pb {
    NSString *absolutePath;
    if (![[NSFileManager defaultManager] fileExistsAtPath: pb.filePath]) {
        absolutePath = [[MEKits currentUserDownloadPath] stringByAppendingPathComponent: pb.filePath];
    }
    UIImage *image;
    if ([[NSFileManager defaultManager] fileExistsAtPath: absolutePath]) {
        image = [[UIImage alloc] initWithContentsOfFile: absolutePath];
    } else {
        image = [UIImage imageNamed: @"baby_content_photo_placeholder"];
    }
    return image;
}

- (void)setCoverImage:(ClassAlbumPb *)pb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    if (pb.isParent) {
        self.playIcon.hidden = true;
        self.floderNameLabel.hidden = NO;
        self.floderNameLabel.text = pb.fileName;
        NSArray *albums = [MEBabyAlbumListVM fetchAlbumsWithParentId: pb.id_p];
        if (albums.count != 0) {
            ClassAlbumPb *firstAlbumPb = albums.firstObject;
            NSString *urlStr;
            if (firstAlbumPb.isParent) {
                ClassAlbumPb *innerPb = [self getTheFirstAlbumCoverImageInFolder: firstAlbumPb.id_p];
                if (innerPb) {
                    if ([innerPb.fileType isEqualToString: @"mp4"]) {
                        urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, innerPb.filePath, QN_VIDEO_FIRST_FPS_URL];
                    } else {
                        urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, innerPb.filePath];
                    }
                } else {
                    self.photoIcon.image = [UIImage imageNamed: @"baby_content_photo_placeholder"];
                    return;
                }
            } else {
                if ([firstAlbumPb.fileType isEqualToString: @"mp4"]) {
                    urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, firstAlbumPb.filePath, QN_VIDEO_FIRST_FPS_URL];
                } else {
                    urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, firstAlbumPb.filePath];
                }
            }
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [self getPlaceHolderImage: pb] options: SDWebImageRetryFailed];
        } else {
            self.photoIcon.image = [UIImage imageNamed: @"baby_content_folder_placeholder"];
        }
    } else {
        self.floderNameLabel.hidden = YES;
        self.floderNameLabel.text = @"";
        if ([pb.fileType isEqualToString: @"mp4"]) {
            self.playIcon.hidden = false;
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [self getPlaceHolderImage: pb] options: SDWebImageRetryFailed];
        } else {
            self.playIcon.hidden = true;
            NSString *urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, pb.filePath];
            [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [self getPlaceHolderImage: pb] options: SDWebImageRetryFailed];
        }
    }
    self.nameBackView.hidden = self.floderNameLabel.hidden;
}

- (IBAction)selectToDeleteTouchEvent:(MEBaseButton *)sender {
    [self changeSelectBtnStatus];
    if (self.handler) {
        self.handler(_albumPb);
    }
}

- (void)changeSelectBtnStatus {
    self.selectBtn.selected = !self.selectBtn.selected;
    self.albumPb.isSelect = self.selectBtn.selected;
}

//when the folderA in folderB, get the folderA's coverImage to give folderB, and maybe floderC in floderA, so this is a recurrence func
- (ClassAlbumPb *)getTheFirstAlbumCoverImageInFolder:(int64_t)parentId {
    ClassAlbumPb *pb = [MEBabyAlbumListVM fetchAlbumsWithParentId: parentId].firstObject;
    if (pb) {
        if (pb.isParent) {
            return [self getTheFirstAlbumCoverImageInFolder: pb.id_p];
        } else {
            return pb;
        }
    } else {
        return nil;
    }
}


@end
