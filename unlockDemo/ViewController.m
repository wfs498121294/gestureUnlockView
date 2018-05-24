//
//  ViewController.m
//  unlockDemo
//
//  Created by wfs on 2018/5/23.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import "ViewController.h"
#import "GestureUnlockVC.h"
#import "TouchIDUnlockVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)touchUnlockClick:(UIButton *)sender {
    
    TouchIDUnlockVC *touchVC = [TouchIDUnlockVC new];
    [self presentViewController:touchVC animated:YES completion:nil];
    
}


- (IBAction)gestureUnlockClick:(UIButton *)sender {
   
    GestureUnlockVC *gestureVC = [[GestureUnlockVC alloc] initWithGestureType:UnlocktypeVerify];
    [self presentViewController:gestureVC animated:YES completion:nil];
    
}


- (IBAction)setGesture:(UIButton *)sender {
    
    GestureUnlockVC *gestureVC = [[GestureUnlockVC alloc] initWithGestureType:UnlocktypeSet];
    [self presentViewController:gestureVC animated:YES completion:nil];
    
}


@end
