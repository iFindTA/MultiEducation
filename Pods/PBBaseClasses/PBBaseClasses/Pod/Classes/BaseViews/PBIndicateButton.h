//
//  PBIndicateButton.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBButton.h"

/**
 custom button in order to add one state: activity indicator for event, such as:network
 */
@interface PBIndicateButton : PBButton

/**
 query current busy state
 */
@property (nonatomic, assign, readonly, getter=wetherBusy) BOOL busyState;

/**
 change current busy state
 
 @param act wether animate
 */
- (void)makeActivity:(BOOL)act;

@end
