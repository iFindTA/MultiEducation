//
//  MEIndexContentScene.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexContentScene.h"
#import "MEContentHeader.h"
#import "MEIndexStoryItemCell.h"

static CGFloat const ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_DISTANCE                               =   200;
static CGFloat const ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_ABS_VALUE                              =   30;

@interface MEIndexContentScene ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 班级类型 分类类别
 */
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) NSUInteger classtype;

/**
 上次的offset y值
 */
@property (nonatomic, assign) CGPoint lastEndOffsetPt;
@property (nonatomic, assign) BOOL whetherTrigger;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSUInteger dataSourceItemCounts;

//header
@property (nonatomic, strong) MEContentHeader *header;

@end

@implementation MEIndexContentScene

- (id)initWithFrame:(CGRect)frame class:(NSString *)cls typeCode:(NSUInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.className = cls.copy;
        self.classtype = type;
        self.dataSource = [NSMutableArray arrayWithArray:[self generateTestData]];
        
        [self addSubview:self.table];
        self.lastEndOffsetPt = CGPointZero;
        //header
        self.table.tableHeaderView = self.header;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark --- lazy load

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (NSArray *)generateTestData {
    NSArray *sectionItems = @[@"推荐视频",@"少儿故事",@"才艺展示"];
    NSUInteger sections = sectionItems.count;NSUInteger count = 9;
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < sections; i++) {
        NSMutableArray *sectItems = [NSMutableArray arrayWithCapacity:0];
        NSString *title = sectionItems[i];
        for (int j = 0; j< count; j++) {
            NSString *str = [NSString stringWithFormat:@"蚂蚁先生搬家---:%d-%d", i, j];
            NSString *image = @"http://img01.taopic.com/180205/267831-1P20523202431.jpg";
            NSDictionary *item = @{@"title":str, @"image":image};
            [sectItems addObject:item];
        }
        NSDictionary *sectMap = @{@"title":title, @"list":sectItems.copy};
        [tmp addObject:sectMap];
    }
    //NSLog(@"%@", tmp.copy);
    return tmp.copy;
}

- (MEContentHeader *)header {
    if (!_header) {
        NSDictionary *map = [NSDictionary new];
        _header = [MEContentHeader headerWithLayoutInfo:map];
    }
    return _header;
}

- (NSUInteger)fetchAllItemCounts {
    NSUInteger sects = self.dataSource.count;
    NSUInteger __rows = 0;
    for (int i = 0; i < sects; i ++) {
        NSDictionary *sectMap = self.dataSource[i];
        NSArray *list = sectMap[@"list"];
        NSUInteger counts = list.count;
        NSUInteger rows = counts / ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
        if (counts % ME_INDEX_STORY_ITEM_NUMBER_PER_LINE != 0) {
            rows += 1;
        }
        __rows += rows;
    }
    
    return __rows;
}

#pragma mark --- UITableView 委托
//*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *map = self.dataSource[section];
    NSString *title = map[@"title"];
    CGRect bounds = CGRectMake(0, 0, MESCREEN_WIDTH, 40);
    MEBaseScene *base = [[MEBaseScene alloc] initWithFrame:bounds];
    bounds = CGRectInset(bounds, ME_LAYOUT_MARGIN, 0);
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:bounds];
    label.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    label.text = title;
    [base addSubview:label];
    return base;
}
//*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectMap = self.dataSource[section];
    NSArray *list = sectMap[@"list"];
    NSUInteger counts = list.count;
    NSUInteger rows = counts / ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    if (counts % ME_INDEX_STORY_ITEM_NUMBER_PER_LINE != 0) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger __row = [indexPath row];
    CGFloat row_height = ME_INDEX_STORY_ITEM_HEIGHT;
    if (__row == 0) {
        row_height = ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT;
    }
    return adoptValue(row_height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"index_content_story_item_cell";
    MEIndexStoryItemCell *cell = (MEIndexStoryItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MEIndexStoryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger __row = [indexPath row];NSUInteger __sect = [indexPath section];
    NSDictionary *sectMap = self.dataSource[__sect];
    NSArray *list = sectMap[@"list"];
    NSString *title = sectMap[@"title"];
    cell.sectionTitleLab.text = title;
    [cell configureStoryItem4RowIndex:__row];
    //item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    for (int i = 0; i < numPerLine; i ++) {
        NSUInteger real_item_index = __row * numPerLine + i;
        if (real_item_index < list.count) {
            NSDictionary *info = list[real_item_index];
            NSString *title = info[@"title"];
            (i % numPerLine == 0)?[cell.leftItemLabel setText:title]:[cell.rightItemLabel setText:title];
            (i % numPerLine == 0)?[cell.leftItemScene setTag:real_item_index]:[cell.rightItemScene setTag:real_item_index];
            cell.tag = __sect;
            NSString *imgUrl = info[@"image"];
            UIImage *image = [UIImage imageNamed:@"index_content_placeholder"];
            if (i % numPerLine == 0) {
                [cell.leftItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            } else {
                [cell.rightItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            }
        } else {
            cell.rightItemScene.hidden = true;
        }
    }
    //callback
    weakify(self)
    cell.indexContentItemCallback = ^(NSUInteger section, NSUInteger index){
        strongify(self)
        [self userDidTouchIndexContentItem:section rowIndex:index];
    };
    
    return cell;
}

#pragma mark -- ScrollView Delegate

/**
 是否达到出发条件
 */
- (BOOL)whetherCanTriggerHidden {
    CGFloat offset_y = self.table.contentOffset.y;
    return offset_y >= ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_DISTANCE;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.table) {
        CGPoint offset = self.table.contentOffset;
        CGFloat offset_y = offset.y;
        self.whetherTrigger = offset_y > ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_DISTANCE;
        if (!self.whetherTrigger) {
            self.lastEndOffsetPt = CGPointZero;
            return;
        }
        //滑到底
        CGFloat height = scrollView.frame.size.height;
        CGFloat distanceFromBottom = scrollView.contentSize.height - offset_y;
        //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,offset_y,scrollView.frame.origin.y);
        if (distanceFromBottom < height) {
            NSLog(@"end of content");
            return;
        }
        
        //超过一定高度接可以触发
        if (!CGPointEqualToPoint(self.lastEndOffsetPt, CGPointZero) && self.whetherTrigger) {
            CGFloat abs = fabs(self.lastEndOffsetPt.y - offset.y);
            if (abs > ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_ABS_VALUE) {
                BOOL hide = self.lastEndOffsetPt.y < offset_y;
                if (self.callback) {
                    self.callback(hide);
                }
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.table) {
        if (self.whetherTrigger) {
            self.lastEndOffsetPt = scrollView.contentOffset;
        }
    }
}

#pragma mark -- method logics

- (void)triggered2fixedSearchBarHideOrShowAction {
    CGPoint offset = self.table.contentOffset;
    CGFloat offset_y = offset.y;
    BOOL hide = offset_y > ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_DISTANCE;
    self.lastEndOffsetPt = hide?offset:CGPointZero;
    if (self.callback) {
        self.callback(hide);
    }
}

- (void)viewWillAppear {
    
}

- (void)viewWillDisappear {
    
}

#pragma mark -- reload ui

#pragma mark --- Touch Item Event

- (void)userDidTouchIndexContentItem:(NSUInteger)section rowIndex:(NSUInteger)row {
    NSDictionary *params = @{@"title":@"蚂蚁先生搬家", @"desc":@"这是对爸爸妈妈说的话，要记牢！"};
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [self handleTransitionError:err];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
