//
//  MEContentSubcategory.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEContentSubcategory.h"
#import "MEVerticalItem.h"
#import <UIButton+AFNetworking.h>

NSUInteger const ME_SUBCATEGORY_ITEM_HEIGHT                                                     =   70;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_4                                                 =   20;
NSUInteger const ME_SUBCATEGORY_ITEM_DISTANCE_5                                                 =   15;
static NSUInteger const ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE                                             =   5;

@interface MEContentSubcategory ()

@property (nonatomic, strong) NSArray <NSDictionary*>*subClasses;

@property (nonatomic, strong) NSMutableArray<MEVerticalItem*>*subItems;

@end

@implementation MEContentSubcategory

+ (instancetype)subcategoryWithClasses:(NSArray *)cls {
    MEContentSubcategory *sub = [[MEContentSubcategory alloc] initWithFrame:CGRectZero subcategoryClasses:cls];
    return sub;
}

- (id)initWithFrame:(CGRect)frame subcategoryClasses:(NSArray *)cls {
    self = [super initWithFrame:frame];
    if (self) {
        self.subClasses = [NSArray arrayWithArray:cls];
        [self __initSubCategoryItems];
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)__initSubCategoryItems {
    [self.subItems removeAllObjects];
    weakify(self)
    [self.subClasses enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"title"];NSString *img = obj[@"img"];
        MEVerticalItem *btn = [MEVerticalItem itemWithTitle:title imageURL:img];
        //btn.backgroundColor = [UIColor pb_randomColor];
        btn.tag = idx;
        [self addSubview:btn];
        [self.subItems addObject:btn];
        strongify(self)
        btn.MESubClassItemCallback = ^(NSUInteger tag){
            if (self.subClassesCallback) {
                self.subClassesCallback(tag);
            }
        };
    }];
    
    [self layoutIfNeeded];
}

- (NSMutableArray<MEVerticalItem*>*)subItems {
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
    NSUInteger itemCountPerLine = [self numbersPerline];
    NSUInteger itemDistance = [self itemDistance];
    NSUInteger margin = ME_LAYOUT_BOUNDARY;
    if (itemCountPerLine == ME_SUBCATEGORY_ITEM_MAXCOUNT_PERLINE) {
        margin = ME_LAYOUT_MARGIN;
    }
    
    NSUInteger itemWidth = ceil((MESCREEN_WIDTH-margin*2-(itemCountPerLine-1)*itemDistance)/itemCountPerLine);
    for ( MEVerticalItem *btn in self.subItems) {
        NSUInteger idx = btn.tag;
        NSUInteger offset_x = margin + (idx % itemCountPerLine) * (itemWidth+itemDistance);
        NSUInteger offset_y = ME_LAYOUT_BOUNDARY + (ME_SUBCATEGORY_ITEM_HEIGHT + ME_LAYOUT_MARGIN*2) * (idx / itemCountPerLine);
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(offset_x);
            make.top.equalTo(self).offset(offset_y);
            make.size.equalTo(CGSizeMake(itemWidth, ME_SUBCATEGORY_ITEM_HEIGHT));
        }];
    }
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
