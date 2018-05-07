//
//  MEMulticastRole.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMulticastRole.h"

@interface MEMulticastRole ()

@property (nonatomic, strong) NSArray<MEPBUser*>*users;

@end

@implementation MEMulticastRole

- (id)initWithFrame:(CGRect)frame users:(NSArray<MEPBUser *> *)list {
    self = [super initWithFrame:frame];
    if (self) {
        self.users = list.copy;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
        
        NSUInteger counts = list.count;
        CGFloat distance = ME_LAYOUT_BOUNDARY;
        CGFloat itemHeight = adoptValue(100);
        CGFloat allHeight = ME_HEIGHT_TABBAR + (itemHeight + distance) * counts;
        //info background
        MEBaseScene *infoBg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        infoBg.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
        infoBg.layer.masksToBounds = true;
        [self addSubview:infoBg];
        [infoBg makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(MESCREEN_WIDTH-ME_LAYOUT_ICON_HEIGHT*2);
            make.height.equalTo(allHeight);
        }];
        //title
        UIFont *font = UIFontPingFangSC(METHEME_FONT_TITLE+1);
        UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
        MEBaseLabel *title = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        title.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
        title.layer.masksToBounds = true;
        title.font = font;
        title.textColor = fontColor;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"选择身份登录";
        [infoBg addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(infoBg);
            make.height.equalTo(ME_HEIGHT_TABBAR);
        }];
        for (int i = 0; i < list.count; i++) {
            MEPBUser *u = list[i];MEPBUserRole role = u.userType;
            NSString *iconString ;
            if (role == MEPBUserRole_Teacher) {
                iconString = @"signin_role_teacher";
            } else if (role == MEPBUserRole_Parent) {
                iconString = @"signin_role_parent";
            } else if (role == MEPBUserRole_Gardener) {
                iconString = @"signin_role_garden";
            }
            UIImage *icon = [UIImage imageNamed:iconString];
            MEBaseScene *itemScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
            itemScene.tag = i;
            itemScene.backgroundColor = UIColorFromRGB(0xFAFAFA);
            itemScene.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
            itemScene.layer.masksToBounds = true;
            [infoBg addSubview:itemScene];
            [itemScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom).offset((itemHeight+distance)*i);
                make.left.equalTo(infoBg).offset(ME_LAYOUT_BOUNDARY);
                make.right.equalTo(infoBg).offset(-ME_LAYOUT_BOUNDARY);
                make.height.equalTo(itemHeight);
            }];
            MEBaseImageView *iconView = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
            iconView.image = icon;
            [itemScene addSubview:iconView];
            [iconView makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(itemScene).offset(ME_LAYOUT_BOUNDARY);
                make.bottom.equalTo(itemScene).offset(-ME_LAYOUT_BOUNDARY);
                make.width.equalTo(iconView.mas_height);
            }];
            //role
            MEBaseLabel *roleLab = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            roleLab.font = UIFontPingFangSCMedium(METHEME_FONT_LARGETITLE-1);
            roleLab.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
            roleLab.text = [self convertType2String:role];
            [itemScene addSubview:roleLab];
            [roleLab makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(itemScene.mas_centerY);
                make.left.equalTo(iconView.mas_right).offset(ME_LAYOUT_MARGIN);
            }];
            //school
            MEBaseLabel *school = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            school.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-1);
            school.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
            school.text = PBAvailableString(u.schoolName);
            [itemScene addSubview:school];
            [school makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemScene.mas_centerY);
                make.left.equalTo(iconView.mas_right).offset(ME_LAYOUT_MARGIN);
            }];
            //arrow
            font = [UIFont fontWithName:@"iconfont" size:METHEME_FONT_TITLE];
            UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectZero];
            arrow.font = font;
            arrow.textColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
            arrow.text = @"\U0000e6f5";
            [itemScene addSubview:arrow];
            [arrow makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemScene.mas_centerY);
                make.right.equalTo(itemScene).offset(-ME_LAYOUT_MARGIN);
                make.width.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
            }];
            //tap gesture
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidSelectUserRoleForTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [itemScene addGestureRecognizer:tap];
        }
        
    }
    return self;
}

/**
 用户类型(1老师;2学生;3家长;4教务)
 */
- (NSString *)convertType2String:(MEPBUserRole)role {
    
    NSString *str = @"家长";
    if (role == 1) {
        str = @"老师";
    } else if (role == 2) {
        str = @"学生";
    } else if (role == 3) {
        str = @"家长";
    } else if (role == 4) {
        str = @"教务";
    }
    
    return str;
}

- (void)userDidSelectUserRoleForTap:(UITapGestureRecognizer *)tap {
    MEBaseScene *scene = (MEBaseScene*)tap.view;
    if (scene) {
        NSUInteger tag = scene.tag;
        if (tag >= self.users.count) {
            return;
        }
        MEPBUser *u = self.users[tag];
        if (self.callback) {
            self.callback(u);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
