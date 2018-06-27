//
//  MECardCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MECardCell.h"
#import "MestuFun.pbobjc.h"
#import "MEBabyFunDelVM.h"
#import "AppDelegate.h"

@interface MECardCell ()

@property (nonatomic, strong) GuFunPhotoPb *pb;

@end

@implementation MECardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addShadow];
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.clipsToBounds = true;
    _coverImage.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(pushToPhotoBrowser)];
    [_coverImage addGestureRecognizer: tapGes];
}

- (void)pushToPhotoBrowser {
    if (self.gotoPhotoBrowserHandler) {
        self.gotoPhotoBrowserHandler(_pb);
    }
}

- (void)setData:(GuFunPhotoPb *)pb {
    _pb = pb;
    self.titleLab.text = pb.title;
    self.subtitleLab.text = pb.funText;
    self.countLab.text = [NSString stringWithFormat: @"共%lu张", (unsigned long)pb.imgListArray.count];
    
    NSString *urlStr;
    NSString *bucket = ((AppDelegate *)[UIApplication sharedApplication].delegate).curUser.bucketDomain;
    if (pb.imgListArray.count > 0) {
        if ([pb.imgListArray.firstObject.imgPath hasSuffix: @".mp4"]) {
            urlStr = [NSString stringWithFormat: @"%@/%@%@", bucket, pb.imgListArray.firstObject.imgPath, QN_VIDEO_FIRST_FPS_URL];
            self.playIcon.hidden = false;
        } else {
            urlStr = [NSString stringWithFormat: @"%@/%@", bucket, pb.imgListArray.firstObject.imgPath];
            self.playIcon.hidden = true;
        }
    }
    [self.coverImage sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage pb_imageWithColor: UIColorFromRGB(0xF3F8F8)]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: pb.createdDate / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate: date];
    if (pb.type == 1) {
        self.markLab.text = [NSString stringWithFormat: @"幼儿园趣事  %@", dateStr];
    } else {
        self.markLab.text = [NSString stringWithFormat: @"家庭趣事  %@", dateStr];
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.pb.createdBy != delegate.curUser.uid) {
        self.delBtn.hidden = true;
    } else {
        self.delBtn.hidden = false;
    }
}

- (IBAction)deleteBabyInteresting:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: @"确定要删除该趣事趣影吗?" preferredStyle: UIAlertControllerStyleActionSheet];
    weakify(self);
    UIAlertAction *dadAc = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self);
        [self confrimDelStuFun];
    }];
    UIAlertAction *momAc = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler: nil];
    [alert addAction: dadAc];
    [alert addAction: momAc];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController: alert animated: true completion: nil];
}

- (void)confrimDelStuFun {
    MEBabyFunDelVM *vm = [MEBabyFunDelVM vmWithPB: self.pb];
    weakify(self);
    [vm postData: self.pb.data hudEnable: true success:^(NSData * _Nullable resObj) {
        strongify(self);
        if (self.didDeleteBabyFunSuccessCallback) {
            self.didDeleteBabyFunSuccessCallback();
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

#pragma mark-添加阴影
- (void)addShadow {
    self.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(-3.0, 3.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.masksToBounds = NO;
}

@end
