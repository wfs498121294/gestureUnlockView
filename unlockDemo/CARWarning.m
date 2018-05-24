//
//  CARWarning.m
//  CarAyo
//
//  Created by jun on 16/8/15.
//  Copyright © 2016年 张乐. All rights reserved.
//

#import "CARWarning.h"
#import "GestureUnlockView.h"
@interface CARWarning()
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSTimer *removeImageTimer;
@end

@implementation CARWarning

+ (CARWarning*)sharedView {
    
    static dispatch_once_t once;
    static CARWarning *sharedView;
    dispatch_once(&once, ^{ sharedView = [[self alloc] init]; });
    return sharedView;
}


+ (void)showText:(NSString *)showText{
    
    [[CARWarning sharedView] showWarningText:showText];
    
}


- (void) showWarningText:(NSString *)warningText{
    
     [self removeFromSuperview];
    
    CGSize requiredSize = [warningText boundingRectWithSize:CGSizeMake(SCREENWIDTH - 40, 44)
                                                    options:
                           NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading
                           
                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
    
    if (!self.statusLabel.superview) {
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, requiredSize.width+30, requiredSize.height+20)];
        [self.statusLabel setFont:[UIFont systemFontOfSize:14]];
        self.statusLabel.text = warningText;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor whiteColor];
        [self.statusLabel setNumberOfLines:0];
    }
    else{
        [self.statusLabel setFrame:CGRectMake(0, 0, requiredSize.width+30, requiredSize.height+20)];
         self.statusLabel.text = warningText;
    }
    
    if (!self.imageView.superview) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.statusLabel.frame.size.width , self.statusLabel.frame.size.height)];
        [self.imageView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2 , [UIScreen mainScreen].bounds.size.height/2 )];//+60
        self.imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
        [self.imageView addSubview:self.statusLabel];
    }
    else{
        
        [self.imageView setFrame:CGRectMake(0, 0, self.statusLabel.frame.size.width , self.statusLabel.frame.size.height)];
        [self.imageView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2 , [UIScreen mainScreen].bounds.size.height/2 )];//+60
    }

    [self setFrame:CGRectMake(0, 0, self.statusLabel.frame.size.width , self.statusLabel.frame.size.height)];
    [self addSubview:self.imageView];
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
     [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    [self addRemoveTimer];
    
}


- (void)addRemoveTimer{
    
    if (self.removeImageTimer) {
        [self.removeImageTimer invalidate];
        self.removeImageTimer = nil;
    }

    self.removeImageTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(readyRemoveWarning) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.removeImageTimer forMode:NSRunLoopCommonModes];
    
}

- (void) readyRemoveWarning{
    
    if (self) {
        [self removeFromSuperview];
        if (self.removeImageTimer) {
            [self.removeImageTimer invalidate];
            self.removeImageTimer = nil;
        }
    }
}

+ (void)dismiss{
    
    [[CARWarning sharedView] readyRemoveWarning];
}





@end
