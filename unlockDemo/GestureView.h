//
//  GestureView.h
//  unlockDemo
//
//  Created by wfs on 2018/5/23.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureView : UIView
@property (nonatomic, copy) void(^gestureEndBlock)(NSString *gesturePassword);
@end
