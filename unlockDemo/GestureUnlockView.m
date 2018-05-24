//
//  GestureUnlockView.m
//  unlockDemo
//
//  Created by wfs on 2018/5/24.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import "GestureUnlockView.h"
#import "GestureView.h"
#import <Masonry.h>
#import <POP.h>
#import "UIViewController+CAR.h"
#import "CARWarning.h"

@interface GestureUnlockView()
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) GestureView *gestureView;
@property (nonatomic,copy)  NSString *gesturePassword;  //第一次密码
@property (nonatomic,copy)  NSString *confirmPassword;  // 验证密码
@property (nonatomic,assign) Unlocktype type;
@property (nonatomic,assign) BOOL setOneTime; //设置过一次
@property (nonatomic,assign) NSInteger mistakecount; //剩余错误次数
@end

@implementation GestureUnlockView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame type:(Unlocktype)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
       [self setup];
    }
    return self;
}

//设置UI
- (void)setup{
    
    [self addGestureView];
    [self addBackBtn];
    [self addStatusLabel];
  
    if (_type == UnlocktypeVerify) {
        [self addBottomBtn];
        self.mistakecount = 5;
    }
    
}


- (void)addBottomBtn{
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:bottomBtn];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(@(-23));
        make.centerX.mas_equalTo(self);
    }];
    
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomBtn setTitle:@"支付密码解锁" forState:0];
    [bottomBtn setTitleColor: [UIColor redColor] forState:0];
    [bottomBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)addBackBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(20);
        make.top.mas_equalTo(self).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn setTitle:@"返回" forState:0];
    [backBtn setTitleColor: [UIColor redColor] forState:0];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)addGestureView{
    
    __weak typeof(self) weakself = self;
    self.gestureView = [[GestureView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT-259)/2.0,SCREENWIDTH, 259)];
    [self addSubview:self.gestureView];
    self.gestureView.gestureEndBlock = ^(NSString *gesturePassword) {
        
        if (weakself.type == UnlocktypeSet) {
            [weakself handleSetGesturePassword:gesturePassword];
        }
        else{
           [weakself handleVerifyGesturePassword:gesturePassword];
        }
    };
}


//验证
//密码错误，你还可以输入4次
//多次输入错误，请5分钟后再试

//设置
//第一次 少于4个点   至少连接4个点，请重新绘制  大于等于4个点  再次输入以确认  少于4个点  至少连接4个点，请重新绘制  大于4个点不正确  密码不一致，请重新设置  请设置手势密码
//验证手势密码
- (void)handleVerifyGesturePassword:(NSString *)gesturePassword{
    
     self.gesturePassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
     self.confirmPassword = gesturePassword;
        __weak typeof(self) weakself = self;
    if (self.gesturePassword&&[weakself.gesturePassword isEqualToString:gesturePassword]) {
        [CARWarning showText:@"验证成功"];
        [[UIViewController currentController] dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        if (self.mistakecount>1) {
            self.mistakecount --;
            self.statusLabel.text = [NSString stringWithFormat:@"密码错误，你还可以输入%ld次",self.mistakecount];
            [self shakeStatusMessage:nil textColor:nil];
        }
        else{
            self.mistakecount --;
            if (self.mistakecount < 0) {
                self.mistakecount = 0;
            }
            self.statusLabel.text = @"多次输入错误，请5分钟后再试";
            self.gestureView.userInteractionEnabled = NO;
            [self shakeStatusMessage:nil textColor:nil];
            
        }
    }
    
}

//设置手势密码
- (void)handleSetGesturePassword:(NSString *)gesturePassword{
    
    if (!_setOneTime) {
        self.gesturePassword = gesturePassword;
    }
    else{
        self.confirmPassword = gesturePassword;
    }
    __weak typeof(self) weakself = self;
    if (!_setOneTime) {//第一次没确认
        
        if (gesturePassword.length < 4) {
            self.statusLabel.text = @"至少连接4个点，请重新绘制";
            [self shakeStatusMessage:nil textColor:nil];
        }
        else{

            self.statusLabel.text = @"再次输入以确认";
            self.statusLabel.textColor = [UIColor blackColor];
            _setOneTime = YES;
        }
        
    }
    else{//第二次
        if (gesturePassword.length < 4) {
            self.statusLabel.text = @"至少连接4个点，请重新绘制";
            [self shakeStatusMessage:nil textColor:nil];
        }
        else{
            if ([self.gesturePassword isEqualToString:self.confirmPassword]) {//设置成功
                [[NSUserDefaults standardUserDefaults] setObject:self.confirmPassword forKey:@"gesturePassword"];
                [CARWarning showText:@"设置成功"];
                [[UIViewController currentController] dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                self.statusLabel.text = @"密码不一致，请重新设置";
                self.gestureView.userInteractionEnabled = NO;
                [self shakeStatusMessage:nil textColor:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [weakself resetStatus];
                });
               
            }
            
        }
    }
    
}


- (void)addStatusLabel{
    
    self.statusLabel = [UILabel new];
    [self addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(@20);
        make.right.mas_equalTo(self).mas_offset(@(-20));
        make.bottom.mas_equalTo(self.gestureView.mas_top).mas_offset(@(-60));
    }];
    
    if (_type == UnlocktypeSet) {
      self.statusLabel.text = @"请设置手势密码";
    }
    else{
      self.statusLabel.text = @"请输入手势密码";
    }

    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)resetStatus{
    
    self.gesturePassword = nil;
    self.setOneTime = NO;
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.text = @"请设置手势密码";
}



- (void)shakeStatusMessage:(NSString *)message textColor:(UIColor *)textcolor{
    
       __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.statusLabel.textColor = [UIColor colorWithRed:216/255.0 green:22/255.0 blue:40/255.0 alpha:1];
        
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        positionAnimation.velocity = @1500;
        positionAnimation.springBounciness = 20;
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            
            if (message) {
                weakself.statusLabel.text = message;
            }
            
            if (textcolor) {
                weakself.statusLabel.textColor = textcolor;
            }
            
            if (weakself.mistakecount>0||weakself.type == UnlocktypeSet) {
                weakself.gestureView.userInteractionEnabled = YES;
            }
            
          
        }];
        [weakself.statusLabel.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    });
 
    
}


- (void)backBtnClick{
    
    [[UIViewController currentController] dismissViewControllerAnimated:YES completion:nil];
    
}

@end
