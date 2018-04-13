//
//  MEChatContent.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyContent.h"
#import "UIView+Frame.h"
#import "MEBabyHeader.h"
#import "MEBabyContentHeader.h"
#import "MEBabyComponentCell.h"
#import "MEBabyInfoCell.h"

#define MAX_BABY_PHOTO 10
#define COMPONENT_COUNT 6

#define BABY_PHOTOVIEW_IDEF @"baby_photoView_idef"
#define SCROLL_CONTENTVIEW_IDEF @"scroll_contentView_idef"
#define BABY_INFO_IDEF @"baby_info_idef"

#define TABLEVIEW_ROW_HEIGHT 102.f
#define TABLEVIEW_SECTION_HEIGHT 44.f

#define TABLEVIEW_TOTAL_HEIGHT TABLEVIEW_ROW_HEIGHT * 10 +

@interface MEBabyContent() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MEBabyHeader *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;

@property (nonatomic, strong) MEBabyContentHeader *photoHeader;
@property (nonatomic, strong) UICollectionView *babyPhtoView;
@property (nonatomic, strong) NSMutableArray *babyPhotos;   //babyPhoto

@property (nonatomic, strong) UICollectionView *componentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr; //table dataArr

@end

@implementation MEBabyContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview: self.scrollView];
    [self.scrollView addSubview: self.scrollContentView];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyHeader" owner:self options:nil] lastObject];
    [self.scrollContentView addSubview: self.headerView];
    
    self.photoHeader = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyContentHeader" owner:self options:nil] lastObject];
    [self.scrollContentView addSubview: self.photoHeader];
    [self.scrollContentView addSubview: self.babyPhtoView];
    [self.scrollContentView addSubview: self.componentView];
    [self.scrollContentView addSubview: self.tableView];
    
    //layoutBackContentView
    
    //in iOS11  scrollView's Y will down scroll 20pt!
    CGFloat toTop;
    if (@available(iOS 11.0, *)) {
        toTop = -20;
    } else {
        toTop = 0;
    }
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(toTop);
    }];
    
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(230.f);
    }];
    
    [self.photoHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(54.f);
    }];
    
    [self.babyPhtoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoHeader.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.scrollContentView.mas_right).mas_offset(-10);
        make.left.mas_equalTo(self.scrollContentView.mas_left).mas_offset(10.f);
        make.height.mas_equalTo(78);
    }];
    
    [self.componentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MESCREEN_WIDTH - 20);
        make.left.mas_equalTo(_scrollContentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.babyPhtoView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(256.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollContentView);
        make.top.mas_equalTo(self.componentView.mas_bottom);
        make.height.mas_equalTo([self tableviewHeight]);
    }];
    
    [self.scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tableView.mas_bottom).mas_offset(10.f);
    }];
}

//let tableView.height = tableView.contentView.height  don't let it can scroll !!!
- (CGFloat)tableviewHeight {
    CGFloat height = 0;
    for (int i = 0; i < [self.tableView numberOfSections]; i++) {
        height += TABLEVIEW_SECTION_HEIGHT;
        height += [self.tableView numberOfRowsInSection: i] * TABLEVIEW_ROW_HEIGHT;
    }
    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual: self.babyPhtoView]) {
        return MAX_BABY_PHOTO;
    } else {
        return COMPONENT_COUNT;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if ([collectionView isEqual: self.babyPhtoView]) {
        //babyPhotoView collectionView cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: BABY_PHOTOVIEW_IDEF forIndexPath: indexPath];
    } else {
//        scrollContentView collectionView cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: SCROLL_CONTENTVIEW_IDEF forIndexPath: indexPath];
        [(MEBabyComponentCell *)cell setItemWithType: 1 << indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        return CGSizeMake(78.f, 78.f);
    } else {
        return CGSizeMake((MESCREEN_WIDTH - 25) / 2, 82.f);
    }
}

#pragma mark - UICollectionViewLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual: self.babyPhtoView]) {
        //babyPhotoView collectionView cell
        NSLog(@"did select babyPhotoView at indexPath.item:%ld", (long)indexPath.item);
    } else {
        //scrollContentView collectionView cell
        
        NSLog(@"did select scrollContentView at indexPath.item:%ld", (long)indexPath.item);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: BABY_INFO_IDEF];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"育儿资讯";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLEVIEW_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select tableview in section:%ld in row:%ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - lazyloading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollContentView;
}

- (UICollectionView *)componentView {
    if (!_componentView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 5.f;
        layout.minimumLineSpacing = 5.f;

        _componentView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _componentView.delegate = self;
        _componentView.dataSource = self;
        _componentView.backgroundColor = [UIColor whiteColor];
        _componentView.showsVerticalScrollIndicator = NO;
        
        [_componentView registerNib: [UINib nibWithNibName: @"MEBabyComponentCell" bundle: nil] forCellWithReuseIdentifier: SCROLL_CONTENTVIEW_IDEF];
    }
    return _componentView;
}

- (UICollectionView *)babyPhtoView {
    if (!_babyPhtoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        layout.itemSize =CGSizeMake(78, 78);
        layout.minimumInteritemSpacing = 5.f;
        
        _babyPhtoView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: layout];
        _babyPhtoView.delegate = self;
        _babyPhtoView.dataSource = self;
        _babyPhtoView.backgroundColor = [UIColor whiteColor];
        _babyPhtoView.showsHorizontalScrollIndicator = NO;
        
        [_babyPhtoView registerNib: [UINib nibWithNibName: @"MEBabyPhotoCell" bundle: nil] forCellWithReuseIdentifier: BABY_PHOTOVIEW_IDEF];
    }
    return _babyPhtoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib: [UINib nibWithNibName: @"MEBabyInfoCell" bundle: nil] forCellReuseIdentifier: BABY_INFO_IDEF];
    }
    return _tableView;
}

@end
