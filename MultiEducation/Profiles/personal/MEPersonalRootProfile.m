//
//  MEPersonalRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEPersonalRootProfile.h"
#import "MEPersonalListCell.h"
#import "MEPersonalVipCell.h"
#import "MEPersonalRecordCell.h"
#import "MEGrowRecordProfile.h"
//#import "MELoginProfile.h"

@interface MEPersonalRootProfile () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *_headerView;
    UITableView *_tableView;
    NSMutableDictionary *_listDataDic;
}

@end

@implementation MEPersonalRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavigationBar];
    _headerView = [self headerView];
    _tableView = [self tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _listDataDic = [self listDataDic];
    [_tableView reloadData];
}

- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, 170)];
    headerView.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    [self.view addSubview:headerView];
    
    UIImageView *headerBgImageView = [[UIImageView alloc] init];
    headerBgImageView.image = [UIImage imageNamed:@"personal_header_bg"];
    [headerView addSubview:headerBgImageView];
    [headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    float leftDistance = 15;
    UIView * headSculptureView = [[UIView alloc] init];
    headSculptureView.layer.cornerRadius = 30;
    headSculptureView.layer.masksToBounds = YES;
    headSculptureView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [headerView addSubview:headSculptureView];
    [headSculptureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDistance);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(headerView.mas_centerY).with.offset(10);
    }];
    
    float offsetY = 2.4f;
    
    MEBaseLabel *nameLabel = [[MEBaseLabel alloc] init];
    nameLabel.text = @"这个杀手不太冷";
    nameLabel.textColor = UIColorFromRGB(0xffffff);
    nameLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headSculptureView.mas_right).with.offset(10);
        make.centerY.equalTo(headSculptureView.mas_centerY).with.offset(-(offsetY + METHEME_FONT_TITLE / 2));
        make.height.mas_equalTo(METHEME_FONT_TITLE);
        make.right.mas_equalTo(headerView.mas_right);
    }];
    
    MEBaseLabel *signatureLabel = [[MEBaseLabel alloc] init];
    signatureLabel.text = @"个性签名";
    signatureLabel.textColor = UIColorFromRGB(0xffffff);
    signatureLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:signatureLabel];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headSculptureView.mas_right).with.offset(10);
        make.centerY.equalTo(headSculptureView.mas_centerY).with.offset(offsetY + METHEME_FONT_SUBTITLE / 2);
        make.height.mas_equalTo(METHEME_FONT_SUBTITLE);
        make.right.mas_equalTo(headerView.mas_right);
    }];
    
    UIImage *setImage = [UIImage imageNamed:@"personal_set_icon"];
    MEBaseButton *setBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:setImage forState:UIControlStateNormal];
    setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headerView addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headSculptureView.mas_centerY);
        make.right.equalTo(headerView.mas_right).with.offset(-leftDistance);
        make.size.mas_equalTo(CGSizeMake(setImage.size.width * 3, setImage.size.height));
    }];
    
    
    return headerView;
}

- (UITableView *)tableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = YES;
    [self.view addSubview:tableView];
    __block UIView *headerView = _headerView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    return tableView;
}

- (NSMutableDictionary *)listDataDic {
    NSMutableDictionary *listDataDic = [NSMutableDictionary new];
    NSArray *baseTitleArr = @[@"历史纪录", @"我的收藏", @"客户服务", @"学习记录", @"账户安全", @"帮助中心", @"反馈"];//@"我的会员"2.0不加；
    
    NSMutableArray *notBaseArr = [NSMutableArray new];
    NSMutableArray *baseArr = [NSMutableArray new];
    for (NSString *title in baseTitleArr) {
        MEPersonalListModel *model = [[MEPersonalListModel alloc] init];
        model.cellTitle = title;
        if ([title isEqualToString:@"我的会员"]) {
            model.cellType = MEPersonalListModelTypeVip;
            [notBaseArr addObject:model];
        } else if ([title isEqualToString:@"历史纪录"]) {
            model.cellType = MEPersonalListModelTypeRecord;
            [notBaseArr addObject:model];
        } else {
            model.cellType = MEPersonalListModelTypeDefault;
            [baseArr addObject:model];
        }
    }
    [listDataDic setObject:notBaseArr forKey:@"0"];
    [listDataDic setObject:baseArr forKey:@"1"];
    
    return listDataDic;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEPersonalListModel *cellModel = [[_listDataDic objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]] objectAtIndex:indexPath.row];
    switch (cellModel.cellType) {
        case MEPersonalListModelTypeVip:
            return vip_cell_height;
             break;
        case MEPersonalListModelTypeRecord:
            return record_cell_height;
            break;
        default:
            return default_cell_height;
            break;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    MEPersonalListModel *cellModel = [[_listDataDic objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]] objectAtIndex:indexPath.row];
    switch (cellModel.cellType) {
        case MEPersonalListModelTypeVip:
        {
            static NSString *CellIdentifier = @"MEPersonalVipCell";
            MEPersonalVipCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[MEPersonalVipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.cellModel = cellModel;
            
            return cell;
        }
            break;
        case MEPersonalListModelTypeRecord:
        {
            static NSString *CellIdentifier = @"MEPersonalRecordCell";
            MEPersonalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[MEPersonalRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.cellModel = cellModel;
            
            return cell;
        }
            break;
            
        default:
        {
            static NSString *CellIdentifier = @"MEPersonalListCell";
            MEPersonalListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[MEPersonalListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.cellModel = cellModel;
            
            return cell;
        }
            break;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _listDataDic.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = [_listDataDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]];
    
    return sectionArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESCREEN_WIDTH, default_cell_height)];
    contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:contentView];
    
    MEBaseLabel *titleLabel = [[MEBaseLabel alloc] initWithFrame:CGRectMake(10, (default_cell_height - METHEME_FONT_TITLE) / 2, 0, 0)];
    titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.text = @"基础功能";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(contentView.mas_bottom).with.offset(-.5);
        make.right.mas_equalTo(contentView.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return default_cell_height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MEGrowRecordProfile *login = [[MEGrowRecordProfile alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];

    }
}


@end
