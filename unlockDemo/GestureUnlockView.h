//
//  GestureUnlockView.h
//  unlockDemo
//
//  Created by wfs on 2018/5/24.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger,Unlocktype){
    UnlocktypeSet,
    UnlocktypeVerify
};
@interface GestureUnlockView : UIView

-(instancetype)initWithFrame:(CGRect)frame type:(Unlocktype)type;
@end
