//
//  MEContentSubcategory.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEContentSubcategory.h"
#import <UIButton+AFNetworking.h>

NSUInteger const ME_SUBCATEGORY_ITEM_HEIGHT                                                     =   70;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_4                                                 =   15;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_5                                                 =   10;
static NSUInteger const ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE                                             =   5;

@interface MEContentSubcategory ()

@property (nonatomic, strong) NSArray <NSDictionary*>*subClasses;

@property (nonatomic, assign) METhemeLayout layoutType;

@property (nonatomic, strong) NSMutableArray<METhemeItem*>*subItems;

@end

@implementation MEContentSubcategory

- (id)initWithFrame:(CGRect)frame classes:(NSArray<NSDictionary *> *)cls layoutType:(METhemeLayout)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutType = type;
        self.subClasses = [NSArray arrayWithArray:cls];
        [self __initSubCategoryItems];
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)__initSubCategoryItems {
    [self.subItems removeAllObjects];
    NSUInteger itemCountPerLine = [self numbersPerline];
    NSUInteger itemDistance = [self itemDistance];
    NSUInteger margin = ME_LAYOUT_BOUNDARY;
    if (itemCountPerLine == ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE) {
        margin = ME_LAYOUT_MARGIN;
    }
    NSUInteger itemWidth = ceil((MESCREEN_WIDTH-margin*2-(itemCountPerLine-1)*itemDistance)/itemCountPerLine);
    __block METhemeItem *lastItem = nil;__block METhemeItem *rowMark = nil;
    weakify(self)
    [self.subClasses enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"title"];NSString *img = obj[@"img"];
        METhemeItem *item = [[METhemeItem alloc] initWithType:self.layoutType];
        item.title = title;
        item.uri = img;
        item.tag = idx;
        [item configureItemSubviews];
        [self addSubview:item];
        [self.subItems addObject:item];
        item.callback = ^(NSUInteger tag){
            strongify(self)
            if (self.subClassesCallback) {
                self.subClassesCallback(tag);
            }
        };
        //layout
        NSUInteger offset_x = margin + (idx % itemCountPerLine) * (itemWidth+itemDistance);
        [item makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((rowMark == nil) ? self : rowMark.mas_bottom).offset(ME_LAYOUT_MARGIN);
            make.left.equalTo(self).offset(offset_x);
            make.width.equalTo(itemWidth);
        }];
        //间隔
        if (self.layoutType == METhemeLayoutLandscape && idx != itemCountPerLine-1) {
            MEBaseScene *line = [[MEBaseScene alloc] initWithFrame:CGRectZero];
            line.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_LINE);
            [self addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(item.mas_right).offset(itemDistance*0.5);
                make.centerY.equalTo(item.mas_centerY);
                make.width.equalTo(ME_LAYOUT_LINE_HEIGHT);
                make.height.equalTo(item.mas_height).multipliedBy(0.5);
            }];
        }
        //行标
        if ((idx >= (itemCountPerLine-1)) && ((idx+1) % itemCountPerLine == 0)) {
            rowMark = item;
        }
        lastItem = item;
    }];
    //bottom margin
    [lastItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-ME_LAYOUT_MARGIN);
    }];
}

- (NSMutableArray<METhemeItem*>*)subItems {
    if (!_subItems) {
        _subItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _subItems;
}

- (NSUInteger)numbersPerline {
    if (self.layoutType == METhemeLayoutLandscape) {
        return METhemeLayoutLandscape-1;
    }
    if (self.subClasses.count >= ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE) {
        return ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE;
    }
    return ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE - 1;
}

- (NSUInteger)itemDistance {
    if ([self numbersPerline] == ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE) {
        return ME_SUBCATEGORY_ITEM_DISTANCE_5;
    }
    return ME_SUBCATEGORY_ITEM_DISTANCE_4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //__block MEVerticalItem *lastBtn;
    
}

+ (NSUInteger)subcategoryClassPanelHeight4Classes:(NSArray *)cls {
    NSUInteger numPerline = ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE - 1;
    if (cls.count >= ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE) {
        numPerline = ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE;
    }
    NSUInteger lines = cls.count / numPerline;
    if (cls.count % numPerline != 0 /*&& lines != 0//*/) {
        lines += 1;
    }
    
    return ME_LAYOUT_BOUNDARY + lines * (ME_SUBCATEGORY_ITEM_HEIGHT+ME_LAYOUT_MARGIN) + ME_LAYOUT_MARGIN;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
