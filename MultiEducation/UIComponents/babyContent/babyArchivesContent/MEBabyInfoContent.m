//
//  MEBabyInfoContent.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInfoContent.h"
#import "MEBabyInfoHeader.h"
#import "MEArchivesView.h"
#import <ActionSheetPicker.h>
#import "AppDelegate.h"
#import "MebabyGrowth.pbobjc.h"
#import <IQKeyboardManager.h>

#define SELF_HEIGHT adoptValue(480.f)
#define SELF_WIDTH adoptValue(320.f)

@interface MEBabyInfoContent()

@property (nonatomic, strong) NSArray *bloodArr;
@property (nonatomic, strong) NSArray *zodiacArr;

@end

@implementation MEBabyInfoContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.header];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.height.mas_equalTo(adoptValue(180));
        }];
        
        [self addSubview: self.heightView];
        [self addSubview: self.weightView];
        [self addSubview: self.nickView];
        [self addSubview: self.nationView];
        [self addSubview: self.bloodView];
        [self addSubview: self.zodiacView];
        [self addSubview: self.leftEyeView];
        [self addSubview: self.rightEyeView];
        [self addSubview: self.HGBView];
        [self addSubview: self.addressView];
 
        CGFloat leftSpace = adoptValue(0.f);
        CGFloat topSpace = adoptValue(20.f);
        CGFloat bottomSpace = adoptValue(70.f);
        CGFloat betWSpace = adoptValue(10);
        CGFloat betHSpace = adoptValue(25.f);
        CGFloat width = (SELF_WIDTH - leftSpace * 2 - 2 * betWSpace) / 3;
        CGFloat height = (SELF_HEIGHT - adoptValue(180) - topSpace - bottomSpace - 2 * betHSpace) / 3;
        CGSize normalSize = CGSizeMake(width, height);
        [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.header.mas_bottom).mas_offset(topSpace);
            make.left.mas_equalTo(self).mas_offset(leftSpace);
        }];
        
        [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.header.mas_bottom).mas_offset(topSpace);
            make.left.mas_equalTo(self.heightView.mas_right).mas_offset(betWSpace);
        }];
        
        [self.nickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.header.mas_bottom).mas_offset(topSpace);
            make.left.mas_equalTo(self.weightView.mas_right).mas_offset(betWSpace);
        }];
        
        [self.nationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.heightView.mas_bottom).mas_offset(betHSpace);
            make.left.mas_equalTo(self.heightView);
        }];
        
        [self.bloodView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.nationView);
            make.left.mas_equalTo(self.weightView);
        }];

        [self.zodiacView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.nationView);
            make.left.mas_equalTo(self.nickView);
        }];

        [self.leftEyeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.top.mas_equalTo(self.nationView.mas_bottom).mas_offset(betHSpace);
            make.left.mas_equalTo(self.heightView);
        }];

        [self.rightEyeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.left.mas_equalTo(_bloodView);
            make.top.mas_equalTo(self.leftEyeView);
        }];

        [self.HGBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(normalSize);
            make.left.mas_equalTo(_zodiacView);
            make.top.mas_equalTo(self.leftEyeView);
        }];
        
        [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(height);
        }];
        
    }
    return self;
}

- (void)setData:(GuStudentArchivesPb *)pb {
    self.header.nameView.originText = pb.studentName;
    NSString *sid = pb.sid == 0 ? @"" : [NSString stringWithFormat: @"%lld", pb.sid];
    [self.header.nameView changeTip: sid];
    NSString *dateStr = [MEKits timeStamp2DateStringWithFormatter: @"yyyy-MM-dd" timeStamp: pb.birthday];
    self.header.birthView.originText = dateStr;
    NSString *bucket = self.currentUser.bucketDomain;
    NSString *portrait = pb.studentPortrait;
    
    [self.header.portrait sd_setImageWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@", bucket, portrait]] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    NSString *gender = pb.gender == 1 ? @"男" : @"女";
    self.header.genderView.originText = gender;
    
    self.heightView.originText = [NSString stringWithFormat: @"%.1f", pb.height];
    self.weightView.originText = [NSString stringWithFormat: @"%.1f", pb.weight];
    self.nickView.originText = pb.petName;
    self.nationView.originText = pb.nation;
    self.bloodView.originText = pb.bloodType;
    self.zodiacView.originText = pb.zodiac;
    self.leftEyeView.originText = [NSString stringWithFormat: @"%.1f", pb.leftVision];
    self.rightEyeView.originText = [NSString stringWithFormat: @"%.1f", pb.rightVision];
    self.HGBView.originText = [NSString stringWithFormat: @"%d", pb.hemoglobin];

//    [self.heightView changeTitle: [NSString stringWithFormat: @"%d", pb.height]];
//    [self.weightView changeTitle: [NSString stringWithFormat: @"%d", pb.weight]];
//    [self.nickView changeTitle: pb.petName];
//    [self.nationView changeTitle: pb.nation];
//    [self.bloodView changeTitle: pb.bloodType];
//    [self.zodiacView changeTitle: pb.zodiac];
//    [self.leftEyeView changeTitle: [NSString stringWithFormat: @"%.1f", pb.leftVision]];
//    [self.rightEyeView changeTitle: [NSString stringWithFormat: @"%.1f", pb.rightVision]];
//    [self.HGBView changeTitle: [NSString stringWithFormat: @"%d", pb.hemoglobin]];
    if (!PBIsEmpty(pb.homeAddress)) {
        self.addressView.originText = pb.homeAddress;
    } else {
        [self.addressView setPlaceHolder: @"家庭住址"];
    }
    
    [self.heightView changeCount: pb.heightRt];
    [self.weightView changeCount: pb.weightRt];
    [self.leftEyeView changeCount: pb.leftVisionRt];
    [self.rightEyeView changeCount: pb.rightVisionRt];
}

- (void)didTapBloodView {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ActionSheetStringPicker showPickerWithTitle: @"选择血型" rows: self.bloodArr initialSelection: 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.bloodView changeTitle: self.bloodArr[selectedIndex]];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin: delegate.window];
}

- (void)didTapZodiacView {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ActionSheetStringPicker showPickerWithTitle: @"选择属相" rows: self.zodiacArr initialSelection: 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.zodiacView changeTitle: self.zodiacArr[selectedIndex]];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin: delegate.window];
}

- (void)changeBabyPortrait:(NSString *)portrait {
    [self.header changeBabyPortrait: portrait];
}

#pragma mark - lazyloading
- (MEBabyInfoHeader *)header {
    if (!_header) {
        _header = [[MEBabyInfoHeader alloc] initWithFrame: CGRectZero];
        weakify(self);
        _header.didTapPortraitCallback = ^ {
            strongify(self);
            self.didTapPortraitCallback();
        };
    }
    return _header;
}

- (MEArchivesView *)heightView {
    if (!_heightView) {
        _heightView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _heightView.isOnlyNumber = true;
        _heightView.title = @"100";
        _heightView.maxNum = 160;
        _heightView.tip = @"身高(cm)";
        _heightView.type = MEArchivesTypeTipCount;
        [_heightView configArchives: true];
    }
    return _heightView;
}

- (MEArchivesView *)weightView {
    if (!_weightView) {
        _weightView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _weightView.isOnlyNumber = true;
        _weightView.title = @"20";
        _weightView.maxNum = 100;
        _weightView.tip = @"体重(kg)";
        _weightView.type = MEArchivesTypeTipCount;
        [_weightView configArchives: true];
    }
    return _weightView;
}

- (MEArchivesView *)nickView {
    if (!_nickView) {
        _nickView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _nickView.title = @"多多";
        _nickView.tip = @"小名";
        _nickView.type = MEArchivesTypeNormal;
        [_nickView configArchives: true];
    }
    return _nickView;
}

- (MEArchivesView *)nationView {
    if (!_nationView) {
        _nationView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _nationView.title = @"汉";
        _nationView.tip = @"民族";
        _nationView.type = MEArchivesTypeNormal;
        [_nationView configArchives: true];
    }
    return _nationView;
}

- (MEArchivesView *)bloodView {
    if (!_bloodView) {
        _bloodView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _bloodView.title = @"A";
        _bloodView.tip = @"血型";
        _bloodView.type = MEArchivesTypeNormal;
        [_bloodView configArchives: false];
        weakify(self);
        _bloodView.didTapArchivesViewCallback = ^{
            strongify(self);
            [self didTapBloodView];
        };
    }
    return _bloodView;
}

- (MEArchivesView *)zodiacView {
    if (!_zodiacView) {
        _zodiacView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _zodiacView.title = @"羊";
        _zodiacView.tip = @"属性";
        _zodiacView.type = MEArchivesTypeNormal;
        [_zodiacView configArchives: false];
        weakify(self);
        _zodiacView.didTapArchivesViewCallback = ^{
            strongify(self);
            [self didTapZodiacView];
        };
    }
    return _zodiacView;
}

- (MEArchivesView *)leftEyeView {
    if (!_leftEyeView) {
        _leftEyeView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _leftEyeView.isOnlyNumber = true;
        _leftEyeView.title = @"4.5";
        _leftEyeView.tip = @"左视力";
        _leftEyeView.maxNum = 5.3;
        _leftEyeView.type = MEArchivesTypeTipCount;
        [_leftEyeView configArchives: true];
    }
    return _leftEyeView;
}

- (MEArchivesView *)rightEyeView {
    if (!_rightEyeView) {
        _rightEyeView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _rightEyeView.isOnlyNumber = true;
        _rightEyeView.title = @"4.7";
        _rightEyeView.tip = @"右视力";
        _rightEyeView.maxNum = 5.3;
        _rightEyeView.type = MEArchivesTypeTipCount;
        [_rightEyeView configArchives: true];
    }
    return _rightEyeView;
}

- (MEArchivesView *)HGBView {
    if (!_HGBView) {
        _HGBView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _HGBView.isOnlyNumber = true;
        _HGBView.title = @"100";
        _HGBView.maxNum = 1000000;
        _HGBView.tip = @"血色素(g/l)";
        _HGBView.type = MEArchivesTypeNormal;
        [_HGBView configArchives: true];
    }
    return _HGBView;
}

- (MEArchivesView *)addressView {
    if (!_addressView) {
        _addressView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _addressView.title = @"";
        _addressView.type = MEArchivesTypeNormal;
        [_addressView configArchives: true];
    }
    return _addressView;
}

- (NSArray *)bloodArr {
    if (!_bloodArr) {
        _bloodArr = @[@"A", @"B", @"AB", @"O"];
    }
    return _bloodArr;
}

- (NSArray *)zodiacArr {
    if (!_zodiacArr) {
        _zodiacArr = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"候", @"鸡", @"狗", @"猪"];
    }
    return _zodiacArr;
}

@end
