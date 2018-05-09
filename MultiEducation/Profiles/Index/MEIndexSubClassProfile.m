//
//  MEIndexSubClassProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoClassVM.h"
#import "MEIndexSubClassProfile.h"
#import "MEIndexStoryItemCell.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MEIndexSubClassProfile ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSDictionary *mapInfo;

@property (nonatomic, assign) NSUInteger totalPages, currentPageIndex;
@property (nonatomic, assign) BOOL whetherDidLoadData;
@property (nonatomic, strong) NSMutableArray <MEPBRes*>*dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation MEIndexSubClassProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.mapInfo = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = self.mapInfo[@"title"];
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.bottom.right.equalTo(self.view);
    }];
    weakify(self)
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        strongify(self)
        if (self.totalPages == 0 || self.currentPageIndex == 0) {
            return;
        }
        if (self.currentPageIndex >= self.totalPages || (self.dataSource.count % 2 != 0)) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [self autoLoadMoreRelevantItems4PageIndex:self.currentPageIndex+1];
    }];
    self.table.mj_footer.hidden = true;
    self.whetherDidLoadData = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataSource.count == 0) {
        self.totalPages = 0;self.currentPageIndex = 0;
        [self autoLoadMoreRelevantItems4PageIndex:1];
    }
}

#pragma mark --- load data

- (NSArray *)generateTestData {
    NSUInteger count = 9;
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i++) {
        NSString *str = [NSString stringWithFormat:@"蚂蚁先生搬家---:%d", i];
        NSString *image = @"http://img01.taopic.com/180205/267831-1P20523202431.jpg";
        NSDictionary *item = @{@"title":str, @"image":image};
        [tmp addObject:item];
    }
    return tmp.copy;
}

- (NSMutableArray<MEPBRes*>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

/**
 加载数据
 */
- (void)autoLoadMoreRelevantItems4PageIndex:(NSUInteger)index {
    NSNumber *typeId = [self.mapInfo objectForKey:@"typeId"];
    MEVideoClassVM *vm = [[MEVideoClassVM alloc] init];
    MEPBRes *res = [[MEPBRes alloc] init];
    [res setResTypeId:typeId.unsignedIntegerValue];
    weakify(self)
    [vm postData:[res data] pageSize:ME_PAGING_SIZE pageIndex:index hudEnable:true success:^(NSData * _Nullable resObj, NSUInteger totalPages) {
        NSError *err;strongify(self)
        MEPBResList *list = [MEPBResList parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
        } else {
            if (index == 1) {
                [self.dataSource removeAllObjects];
            }
            NSLog(@"total pages:%zd", totalPages);
            self.totalPages = totalPages;
            self.currentPageIndex = index;
            [self.dataSource addObjectsFromArray:list.resPbArray.copy];
            [self.table reloadData];
        }
        [self adjustRefreshFooterState];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [MEKits handleError:error];
        [self adjustRefreshFooterState];
    }];
}

- (void)adjustRefreshFooterState {
    self.whetherDidLoadData = true;
    [self.table.mj_footer endRefreshing];
    if (self.dataSource.count == 0) {
        [self.table reloadEmptyDataSet];
    }
    if (self.totalPages == 0 || self.currentPageIndex == 0) {
        self.table.mj_footer.hidden = true;
        return;
    }
    if (self.currentPageIndex >= self.totalPages || (self.dataSource.count % 2 != 0)) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    if (self.table.contentSize.height >= self.table.bounds.size.height) {
        [self.table.mj_footer resetNoMoreData];
    }
}

#pragma mark --- lazy getter

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

#pragma mark --- DZNEmpty DataSource & Deleagte

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataSource.count == 0 && self.whetherDidLoadData;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *imgColor =UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *image = [UIImage pb_iconFont:nil withName:ME_ICONFONT_EMPTY_HOLDER withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_TITLE;
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_DESC;
    if ([[PBService shared] netState] == PBNetStateUnavaliable) {
        text = ME_EMPTY_PROMPT_NETWORK;
    }
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSC(METHEME_FONT_SUBTITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return adoptValue(ME_EMPTY_PROMPT_OFFSET);
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return true;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self autoLoadMoreRelevantItems4PageIndex:1];
}

#pragma mark --- UITableView Deleagte & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger counts = self.dataSource.count;
    NSUInteger rows = counts / ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    if (counts % ME_INDEX_STORY_ITEM_NUMBER_PER_LINE != 0) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger __row = [indexPath row];
    CGFloat row_height = ME_INDEX_STORY_ITEM_HEIGHT;
    return row_height;
//    if (__row == 0) {
//        row_height = ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT;
//    }
//    return adoptValue(row_height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"index_content_story_item_cell";
    MEIndexStoryItemCell *cell = (MEIndexStoryItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MEIndexStoryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger __row = [indexPath row];
    NSUInteger allCounts = self.dataSource.count;
    [cell configureStoryItem4RowIndex:1];
    //item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    for (int i = 0; i < numPerLine; i ++) {
        NSUInteger real_item_index = __row * numPerLine + i;
        if (real_item_index < allCounts) {
            MEPBRes *res = self.dataSource[real_item_index];
            NSString *title = res.title.copy;
            (i % numPerLine == 0)?[cell.leftItemLabel setText:title]:[cell.rightItemLabel setText:title];
            (i % numPerLine == 0)?[cell.leftItemScene setTag:real_item_index]:[cell.rightItemScene setTag:real_item_index];
            
            NSString *imgUrl = [MEKits imageFullPath:res.coverImg];
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
        [self subClassesStoryItemDidTouchRowIndex:index];
    };
    
    return cell;
}

#pragma mark --- story item touch event

- (void)subClassesStoryItemDidTouchRowIndex:(NSUInteger)index {
    NSArray<MEPBRes*>*list = self.dataSource.copy;
    if (index >= list.count) {
        return;
    }
    MEPBRes *res = list[index];
    NSNumber *vid = @(res.resId);NSNumber *resType = @(res.type);
    NSString *title = PBAvailableString(res.title); NSString *coverImg = PBAvailableString(res.coverImg);
    NSDictionary *params = @{@"vid":vid, @"type":resType, @"title":title, @"coverImg":coverImg};
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
