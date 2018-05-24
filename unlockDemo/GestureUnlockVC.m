//
//  GestureUnlockVC.m
//  unlockDemo
//
//  Created by wfs on 2018/5/23.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import "GestureUnlockVC.h"
#import <Masonry.h>


@interface GestureUnlockVC ()
@property (nonatomic,assign) Unlocktype unlockType;
@end

@implementation GestureUnlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureUnlockView];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(instancetype)initWithGestureType:(Unlocktype)gestureType{
    
    self = [super init];
    if (self) {
        _unlockType = gestureType;
    }
    return self;
}

- (void)addGestureUnlockView{
    
    GestureUnlockView *unlockView = [[GestureUnlockView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) type:self.unlockType];
    [self.view addSubview:unlockView];
    
}



@end
