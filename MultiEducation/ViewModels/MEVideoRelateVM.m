//
//  MEVideoRelateVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoRelateVM.h"
#import "MEIndexStoryItemCell.h"
#import "MEPlayInfoTitlePanel.h"
#import "MEPlayInfoSubTitlePanel.h"

@interface MEVideoRelateVM () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UITableView *weakTable;

@end

@implementation MEVideoRelateVM

+ (instancetype)vmWithRelateVideoID:(NSString *)vid table:(UITableView *)table {
    MEVideoRelateVM *vm = [[MEVideoRelateVM alloc] init];
    vm.vid = vid.copy;
    vm.weakTable = table;
    return vm;
}

- (void)loadRelateVideos {
    self.weakTable.delegate = self;
    self.weakTable.dataSource = self;
    self.dataSource = [NSMutableArray arrayWithArray:[self generateTestData]];
    [self.weakTable reloadData];
    //subaTitle
    MEPlayInfoSubTitlePanel *subPanel = [MEPlayInfoSubTitlePanel configreInfoSubTitleDescriptionPanelWithInfo:@"这是一首歌"];
    self.weakTable.tableHeaderView = subPanel;
}

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
    NSUInteger __row = [indexPath row];
    NSUInteger allCounts = self.dataSource.count;
    cell.sectionTitleLab.text = @"推荐视频";
    [cell configureStoryItem4RowIndex:__row];
    //item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    for (int i = 0; i < numPerLine; i ++) {
        NSUInteger real_item_index = __row * numPerLine + i;
        if (real_item_index < allCounts) {
            NSDictionary *info = self.dataSource[real_item_index];
            NSString *title = info[@"title"];
            (i % numPerLine == 0)?[cell.leftItemLabel setText:title]:[cell.rightItemLabel setText:title];
            (i % numPerLine == 0)?[cell.leftItemScene setTag:real_item_index]:[cell.rightItemScene setTag:real_item_index];
            
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
        [self videoPlayVMRelativeStoryItemDidTouchRowIndex:index];
    };
    
    return cell;
}

- (void)videoPlayVMRelativeStoryItemDidTouchRowIndex:(NSUInteger)index {
    //whether judge should reload
    
    if (self.videoRelativeCallback) {
        self.videoRelativeCallback(@"");
    }
    [self updateRelativeDatas];
}

- (void)updateRelativeDatas {
    
}

@end
