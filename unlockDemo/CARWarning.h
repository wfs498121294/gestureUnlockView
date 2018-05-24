//
//  CARWarning.h
//  CarAyo
//
//  Created by jun on 16/8/15.
//  Copyright © 2016年 张乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CARWarning : UIView

/*
 用于弹窗提醒文案
 */

+ (void)showText:(NSString *)showText;

+ (void)dismiss;
@end
