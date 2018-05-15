//
//  MEContentSubcategory.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "METhemeItem.h"
#import "MEContentSubcategory.h"
#import <UIButton+AFNetworking.h>

NSUInteger const ME_SUBCATEGORY_ITEM_HEIGHT                                                     =   70;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_4                                                 =   20;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_5                                                 =   15;
static NSUInteger const ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE                                             =   5;

@interface MEContentSubcategory ()

@property (nonatomic, strong) NSArray <NSDictionary*>*subClasses;

@property (nonatomic, copy) NSString *layoutType;

@property (nonatomic, strong) NSMutableArray<METhemeItem*>*subItems;

@end

@implementation MEContentSubcategory

- (id)initWithFrame:(CGRect)frame classes:(NSArray<NSDictionary *> *)cls layoutType:(NSString *)type {
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
        NSUInteger offset_y = ME_LAYOUT_BOUNDARY + (ME_SUBCATEGORY_ITEM_HEIGHT + ME_LAYOUT_MARGIN*2) * (idx / itemCountPerLine);
        [item makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(offset_y);
            //make.top.equalTo((rowMark == nil) ? self : rowMark.mas_bottom).offset(ME_LAYOUT_MARGIN);
            make.left.equalTo(self).offset(offset_x);
            make.width.equalTo(itemWidth);
            //make.height.equalTo(ME_SUBCATEGORY_ITEM_HEIGHT);
        }];
        if ((idx >= (itemCountPerLine-1)) && (idx % itemCountPerLine == 0)) {
            rowMark = item;
        }
        lastItem = item;
    }];
    //bottom margin
    [lastItem makeConstraints:^(MASConstraintMaker *make) {
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
