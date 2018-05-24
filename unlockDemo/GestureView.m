//
//  GestureView.m
//  unlockDemo
//
//  Created by wfs on 2018/5/23.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import "GestureView.h"

#define BtnSpace 41
#define BtnWidth 59
#define BtnCount 9
#define row 3 //总列数
#define linWidth 4 //总列数

@interface GestureView()

@property (nonatomic,strong) NSMutableArray *selectedBtns;
@property (nonatomic,assign) CGPoint currentPoint;

@end

@implementation GestureView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)layoutSubviews{
    
   [super layoutSubviews];
   
    CGFloat margin = (self.bounds.size.width - row * BtnWidth-(row-1)*BtnSpace) / 2;//边距
    
    //行 和 列
    NSInteger currentrow = 0;
    NSInteger currentColumn = 0;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (NSInteger index = 0; index<BtnCount; index++) {
      
        currentrow = index/row;
        currentColumn = index%row;
        
        x = margin+currentColumn*(BtnWidth+BtnSpace);
        y = currentrow*(BtnWidth+BtnSpace);
  
        
        UIButton *btn = self.subviews[index];
        [btn setFrame:CGRectMake(x, y, BtnWidth, BtnWidth)];
    }
    
}

-(void)drawRect:(CGRect)rect{
    
    if (self.selectedBtns.count == 0) return;
    // 把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = self.selectedBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.selectedBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint ];
    
    [[UIColor colorWithRed:255/255.0 green:124/255.0 blue:13/255.0 alpha:1] set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = linWidth;
    [path stroke];
    
    
}


- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBtns = @[].mutableCopy;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    for (NSInteger index = 0; index<BtnCount; index++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_unlock_default"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_unlock_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = index+100;
    }
    
}


- (void)pan:(UIPanGestureRecognizer *)gesture{
    
    _currentPoint = [gesture locationInView:self];
     [self setNeedsDisplay];
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, _currentPoint)&&!btn.selected) {
            btn.selected = YES;
            [self.selectedBtns addObject:btn];
        }
    }
    
    [self layoutIfNeeded];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //保存输入密码
        NSMutableString *gesturePwd = [NSMutableString string];
        for (UIButton *button in self.selectedBtns) {
            [gesturePwd appendFormat:@"%ld",button.tag-100];
            button.selected = NO;
        }
        [self.selectedBtns removeAllObjects];
        
        //手势密码绘制完成后回调
        !self.gestureEndBlock?:self.gestureEndBlock(gesturePwd);
    }
}

@end
