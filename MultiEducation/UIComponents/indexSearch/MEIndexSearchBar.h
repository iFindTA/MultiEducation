//
//  MEIndexSearchBar.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@class MESearchBar;
@interface MEIndexSearchBar : MEBaseScene

@property (nonatomic, copy) void(^callback)(BOOL);

@property (nonatomic, strong) IBOutlet MESearchBar *searchBar;

@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;

/**
 被动去失去焦点 但不结束搜索状态 即不是点击取消按钮
 */
- (void)passive2ResignFirsetResponder;

@end


@protocol MEIndexSearchBarDelegate <NSObject>
@optional

- (void)searchBarDid;

@end
