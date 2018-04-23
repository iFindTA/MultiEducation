//
//  MEEditScene.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEEditScene : MEBaseScene <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end
