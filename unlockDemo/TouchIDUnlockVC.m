//
//  TouchIDUnlockVC.m
//  unlockDemo
//
//  Created by wfs on 2018/5/23.
//  Copyright © 2018年 Allintask. All rights reserved.
//

#import "TouchIDUnlockVC.h"
#import <Masonry.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface TouchIDUnlockVC ()
@property(nonatomic,strong) UILabel *resultLabel;
@end

@implementation TouchIDUnlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackBtn];
    [self addResultUI];
    [self touchIDunlock];
  
}


- (void)addBackBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.view).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
     backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn setTitle:@"返回" forState:0];
    [backBtn setTitleColor: [UIColor redColor] forState:0];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addResultUI{
    
    
    self.resultLabel = [UILabel new];
    [self.view addSubview:self.resultLabel];
    
    self.resultLabel.font = [UIFont systemFontOfSize:13];
    self.resultLabel.textColor = [UIColor redColor];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    self.resultLabel.hidden = YES;
    
}


- (void)touchIDunlock{
    
    LAContext *myContext = [LAContext new];
    
    NSError *unlockError = nil;
    NSString *myLocalizedReasonString = @"请验证已有的指纹，打开钱包";
    
    __weak typeof(self) weakself = self;

    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&unlockError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                weakself.resultLabel.hidden = NO;
                weakself.resultLabel.text = @"解锁成功";
            }
            else{
                [weakself CheckTouchIDStateBlockWith:error message:nil success:NO];
            }

        }];
    }
    else{

         [self CheckTouchIDStateBlockWith:unlockError message:nil success:NO];
        
    }
    
}


- (NSDictionary *)CheckTouchIDStateBlockWith:(NSError *)error message:(NSString *)message success:(BOOL)success
{
    if(success)
    {
        message = @"指纹识别成功";
    }
    else
    {
        // 错误码
        switch (error.code)
        {
            case LAErrorAuthenticationFailed: // Authentication was not successful, because user failed to provide valid credentials
            {
                NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                message = @"授权失败";
            }
                break;
            case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
            {
                NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                message = @"用户取消验证";
            }
                break;
            case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
            {
                NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                message = @"用户选择输入密码";
            }
                break;
            case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
            {
                NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                message = @"取消授权";
            }
                break;
            case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.

            {
                NSLog(@"设备系统未设置密码"); // -5
                message = @"设备未处于安全保护中";
                [self gotosetting];
            }
                break;
            case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
            {
                NSLog(@"设备未设置Touch ID"); // -6
                message = @"设备没有注册过指纹";
                [self gotosetting];
            }
                break;
            case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
            {
                NSLog(@"用户未录入指纹"); // -7
                message = @"设备没有注册过指纹";
                [self gotosetting];
            }
                break;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
            case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
            {
                NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                message = @"Touch ID被锁，需要用户输入密码解锁";
            }
                break;
            case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
            {
                NSLog(@"用户不能控制情况下APP被挂起"); // -9
                message = @"用户不能控制情况下APP被挂起";
            }
                break;
            case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
            {
                NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                message = @"指纹识别失败";
            }
                break;
#else
#endif
            default:
            {
                message = @"指纹识别失败";
                break;
            }
        }
    }
    NSDictionary *dic = @{
                          @"message" : message,
                          };
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.resultLabel.text = message;
        weakself.resultLabel.hidden = NO;
    });

    return dic;
}

- (void)backBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)gotosetting{
    
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=TOUCHID_PASSCODE"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
