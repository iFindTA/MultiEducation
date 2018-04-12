//
//  MEIndexContentScene.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexContentScene.h"
#import "MEContentHeader.h"
#import "MEIndexContentCell.h"
#import "MEIndexContentTitleCell.h"

static CGFloat const ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_DISTANCE                               =   200;
static CGFloat const ME_HIDE_SEARCH_SUBNAVIGATIONBAR_TRIGGER_ABS_VALUE                              =   30;
static NSUInteger const ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE                                       =   2;

static NSUInteger const ME_INDEX_CONTENT_ITEM_HEIGHT                                                =   140;
static NSUInteger const ME_INDEX_CONTENT_ITEM_TITLE_HEIGHT                                          =   160;
static NSString  * ME_INDEX_CONTENT_ITEM_IDENTIFIER                                                 =   @"index_content_cell";
static NSString  * ME_INDEX_CONTENT_ITEM_TITLE_IDENTIFIER                                           =   @"index_content_title_cell";

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
        
        //register cell
        //[self.table registerClass:[MEIndexContentCell class] forCellReuseIdentifier:ME_INDEX_CONTENT_ITEM_IDENTIFIER];
        [self.table registerNib:[UINib nibWithNibName:@"MEIndexContentCell" bundle:nil] forCellReuseIdentifier:ME_INDEX_CONTENT_ITEM_IDENTIFIER];
        [self.table registerNib:[UINib nibWithNibName:@"MEIndexContentTitleCell" bundle:nil] forCellReuseIdentifier:ME_INDEX_CONTENT_ITEM_TITLE_IDENTIFIER];
        
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
        NSUInteger rows = counts / ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE;
        if (counts % ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE != 0) {
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
    NSUInteger rows = counts / ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE;
    if (counts % ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE != 0) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger __row = [indexPath row];
    if (__row == 0) {
        return ME_INDEX_CONTENT_ITEM_TITLE_HEIGHT;
    }
    return ME_INDEX_CONTENT_ITEM_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }//*/
    
    NSUInteger __row = [indexPath row];NSUInteger __sect = [indexPath section];
    //
    NSDictionary *sectMap = self.dataSource[__sect];
    NSArray *list = sectMap[@"list"];
    if (__row == 0) {
        MEIndexContentTitleCell * cell = [self.table dequeueReusableCellWithIdentifier:ME_INDEX_CONTENT_ITEM_TITLE_IDENTIFIER];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MEIndexContentTitleCell" owner:self options:nil];
            cell = nibs.firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //标题
        NSString *title = sectMap[@"title"];
        cell.titleLab.text = title;
        //item
        NSUInteger numPerLine = ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE;
        for (int i = 0; i < numPerLine; i ++) {
            NSUInteger real_item_index = __row * numPerLine + i;
            if (real_item_index < list.count) {
                NSDictionary *info = list[real_item_index];
                NSString *title = info[@"title"];
                (i % numPerLine == 0)?[cell.leftTitleLab setText:title]:[cell.rightTitleLab setText:title];
                (i % numPerLine == 0)?[cell.leftScene setTag:real_item_index]:[cell.rightScene setTag:real_item_index];
                cell.tag = __sect;
                NSString *imgUrl = info[@"image"];
            } else {
                cell.rightScene.hidden = true;
            }
        }
        //callback
        weakify(self)
        cell.MEIndexItemCallback = ^(NSUInteger section, NSUInteger index){
            strongify(self)
            [self userDidTouchIndexContentItem:section rowIndex:index];
        };
        return cell;
    } else {
        MEIndexContentCell * cell = [self.table dequeueReusableCellWithIdentifier:ME_INDEX_CONTENT_ITEM_IDENTIFIER];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MEIndexContentCell" owner:self options:nil];
            cell = nibs.firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //item
        NSUInteger numPerLine = ME_INDEX_CONTENT_ITEM_NUMBER_PER_LINE;
        for (int i = 0; i < numPerLine; i ++) {
            NSUInteger real_item_index = __row * numPerLine + i;
            if (real_item_index < list.count) {
                NSDictionary *info = list[real_item_index];
                NSString *title = info[@"title"];
                (i % 2 == 0)?[cell.leftTitleLab setText:title]:[cell.rightTitleLab setText:title];
                (i % numPerLine == 0)?[cell.leftScene setTag:real_item_index]:[cell.rightScene setTag:real_item_index];
                cell.tag = __sect;
            } else {
                cell.rightScene.hidden = true;
            }
        }
        
        //callback
        weakify(self)
        cell.MEIndexItemCallback = ^(NSUInteger section, NSUInteger index){
            strongify(self)
            [self userDidTouchIndexContentItem:section rowIndex:index];
        };
        
        return cell;
    }
    
    //cell.textLabel.text = info[@"title"];
    
    return nil;
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
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    //NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK:callBack};
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    if (err) {
        NSLog(err.description);
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
