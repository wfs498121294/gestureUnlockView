//
//  UIViewController+CAR.m
//  CarAyo
//
//  Created by Yu on 2017/5/23.
//  Copyright © 2017年 jun. All rights reserved.
//

#import "UIViewController+CAR.h"

@implementation UIViewController (CAR)


+ (UIViewController*)currentController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}



@end
