//
//  MEBabyInfoHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInfoHeader.h"
#import "MEArchivesView.h"
#import "AppDelegate.h"
#import <ActionSheetPicker.h>

@interface MEBabyInfoHeader()
@property (nonatomic, strong) MEBaseImageView *backImage;
@end

@implementation MEBabyInfoHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.backImage];
        //layout
        [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self addSubview: self.genderView];
        [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(adoptValue(40));
            make.left.mas_equalTo(self).mas_offset(adoptValue(20));
            make.width.mas_equalTo(80.f);
            make.height.mas_equalTo(50.f);
        }];
        
        [self addSubview: self.portrait];
        [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(adoptValue(24));
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(adoptValue(80));
        }];
        [self.portrait layoutIfNeeded];
        self.portrait.layer.cornerRadius = self.portrait.frame.size.width / 2;
        self.portrait.layer.masksToBounds = true;
        
        [self addSubview: self.birthView];
        [self.birthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.genderView);
            make.right.mas_equalTo(self).mas_offset(-adoptValue(10));
            make.height.mas_equalTo(self.genderView);
            make.left.mas_equalTo(self.portrait.mas_right).mas_offset(adoptValue(10));
        }];
        
        [self addSubview: self.nameView];
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.portrait.mas_bottom).mas_offset(adoptValue(14.f));
            make.height.mas_equalTo(self.genderView);
            make.left.right.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)didTapGenderView {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ActionSheetStringPicker showPickerWithTitle: @"选择性别" rows: @[@"男", @"女"] initialSelection: 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            [self.genderView changeTitle: @"男"];
        } else {
            [self.genderView changeTitle: @"女"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_EDIT_BABY_ARCHIVES" object: nil];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin: delegate.window];
}

- (void)didTapBirthView {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString: self.birthView.title];
    AppDelegate *delegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ActionSheetDatePicker showPickerWithTitle:@"选择生日" datePickerMode: UIDatePickerModeDate selectedDate: date minimumDate: [NSDate dateWithTimeIntervalSince1970: 0] maximumDate: [NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter stringFromDate: selectedDate];
        [self.birthView changeTitle: dateStr];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_EDIT_BABY_ARCHIVES" object: nil];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin: delegate.window];
}

- (void)didTapPortriat {
    if (self.currentUser.userType == MEPBUserRole_Gardener) {
        return;
    }
    if (self.didTapPortraitCallback) {
        self.didTapPortraitCallback();
    }
}

- (void)changeBabyPortrait:(NSString *)portrait {
    NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, portrait];
    [self.portrait sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_EDIT_BABY_ARCHIVES" object: nil];
}

#pragma mark - lazyloading
- (MEBaseImageView *)backImage {
    if (!_backImage) {
        _backImage = [[MEBaseImageView alloc] initWithFrame: CGRectZero];
        _backImage.image = [UIImage imageNamed: @"baby_archives_baby_info_backimage"];
    }
    return _backImage;
}

- (MEArchivesView *)genderView {
    if (!_genderView) {
        _genderView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _genderView.title = @"男";
        _genderView.tip = @"性别";
        _genderView.titleTextColor = [UIColor whiteColor];
        _genderView.tipTextColor = [UIColor whiteColor];
        _genderView.type = MEArchivesTypeNormal;
        [_genderView configArchives: false];
        weakify(self);
        _genderView.didTapArchivesViewCallback = ^{
            strongify(self);
            [self didTapGenderView];
        };
    }
    return _genderView;
}

- (MEBaseImageView *)portrait {
    if (!_portrait) {
        _portrait = [[MEBaseImageView alloc] init];
        _portrait.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapPortriat)];
        [_portrait addGestureRecognizer: tapGes];
    }
    return _portrait;
}

- (MEArchivesView *)birthView {
    if (!_birthView) {
        _birthView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _birthView.title = @"2000-10";
        _birthView.tip = @"生日";
        _birthView.titleTextColor = [UIColor whiteColor];
        _birthView.tipTextColor = [UIColor whiteColor];
        _birthView.type = MEArchivesTypeNormal;
        [_birthView configArchives: false];
        weakify(self);
        _birthView.didTapArchivesViewCallback = ^{
            strongify(self);
            [self didTapBirthView];
        };
    }
    return _birthView;
}

- (MEArchivesView *)nameView {
    if (!_nameView) {
        _nameView = [[MEArchivesView alloc] initWithFrame: CGRectZero];
        _nameView.title = @"黄多多";
        _nameView.tip = @"371326200010100052";
        _nameView.titleTextColor = [UIColor whiteColor];
        _nameView.tipTextColor = [UIColor whiteColor];
        _nameView.type = MEArchivesTypeNormal;
        [_nameView configArchives: true];
    }
    return _nameView;
}


@end
