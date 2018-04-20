//
//  MECollectionViewCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentPhotoCell.h"

@implementation MEBabyContentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.floderNameLabel.hidden = YES;
}

- (void)setData:(MEPhoto *)photo {
    

    self.floderNameLabel.text = photo.albumPb.fileName;
    if (photo.albumPb.isParent) {
        self.floderNameLabel.hidden = NO;
    } else {
        self.floderNameLabel.hidden = YES;
    }
    
    if ([photo.albumPb.fileType isEqualToString: @"mp4"]) {
        self.photoIcon.image = photo.image;
    } else {
       [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: photo.urlStr]];
    }
}

//- (void)setPhotoIconImage:(MEPhoto *)photo {
//    if ([photo.albumPb.fileType isEqualToString: @"mp4"]) {
//        dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat: @"get_video_cover_image_%@", photo.albumPb.fileName] UTF8String],  NULL);
//        dispatch_async(queue, ^{
//            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: [NSURL URLWithString: photo.albumPb.filePath] options:nil];
//            NSParameterAssert(asset);
//            AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
//            assetImageGenerator.appliesPreferredTrackTransform = YES;
//            assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
//            CGImageRef thumbnailImageRef = NULL;
//            CFTimeInterval thumbnailImageTime = 0.1;
//            NSError *thumbnailImageGenerationError = nil;
//            thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
//            UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
//            photo.image = thumbnailImage;
//        });
//    }
//}



@end
