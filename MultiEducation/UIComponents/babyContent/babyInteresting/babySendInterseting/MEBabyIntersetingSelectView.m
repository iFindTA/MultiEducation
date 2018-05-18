//
//  MEBabyIntersetingSelectView.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyIntersetingSelectView.h"

@interface MEBabyIntersetingSelectView ()

@property (weak, nonatomic) IBOutlet MEBaseImageView *firstBabyIcon;

@property (weak, nonatomic) IBOutlet MEBaseImageView *secondBabyIcon;

@property (weak, nonatomic) IBOutlet MEBaseImageView *thirdBabyIcon;

@property (weak, nonatomic) IBOutlet MEBaseImageView *fourthBabyIcon;

@property (weak, nonatomic) IBOutlet MEBaseImageView *fifthBabyIcon;

@property (nonatomic, strong) NSArray <MEBaseImageView *> *iconViewArr;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MEBabyIntersetingSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapSelectBabyView)];
    [self addGestureRecognizer: tapGes];
}

- (void)didTapSelectBabyView {
    NSLog(@"didTapSelectBabyView");
}

- (void)setData:(NSArray *)babyIconArr {
    int i = 0;
    for (MEBaseImageView *icon in self.iconViewArr) {
        //FIXME: 拿到baby 头像的urlString后赋值 self.dataArr[i][@""]
        [icon sd_setImageWithURL: [NSURL URLWithString: @""]  placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
        i++;
    }

}

#pragma mark - lazyloading
- (NSArray<MEBaseImageView *> *)iconViewArr {
    if (!_iconViewArr) {
        _iconViewArr = @[_firstBabyIcon, _secondBabyIcon, _thirdBabyIcon, _fourthBabyIcon, _fifthBabyIcon];
    }
    return _iconViewArr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
