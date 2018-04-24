//
//  MESearchPanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

NS_ASSUME_NONNULL_BEGIN
@class MESearchBar;
@interface MESearchPanel : MEBaseScene

@property (nonatomic, strong, readonly, nullable) MESearchBar *searchBar;

@property (nonatomic, copy) void(^_Nullable searchPanelFirstResponder)(BOOL first);

@end

NS_ASSUME_NONNULL_END
