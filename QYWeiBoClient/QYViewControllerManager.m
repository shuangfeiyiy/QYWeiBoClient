//
//  QYViewControllerManager.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYViewControllerManager.h"
#import "QYLoginViewController.h"
#import "QYUserGuideViewController.h"
#import "QYMainViewController.h"

@implementation QYViewControllerManager

+ (void)presentQYController:(QYViewControllerType)controllerType
{
    UIViewController *controller = [[[self alloc] init] controllerByType:controllerType];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = controller;
}

- (UIViewController *)controllerByType:(QYViewControllerType)type
{
    UIViewController *controller = nil;
    
    switch (type) {
        case QYControllerTypeUserGuideView:
            controller = [self helpViewController];
            break;
        case QYControllerTypeLoginView:
            controller = [self loginViewController];
            break;
        case QYControllerTypeMainView:
            controller = [self mainViewController];
            break;
            
        default:
            break;
    }
    
    return controller;
}

- (QYLoginViewController *)loginViewController
{
    QYLoginViewController *login = [[QYLoginViewController alloc] init];
    return login;
}

- (QYUserGuideViewController *)helpViewController
{
    QYUserGuideViewController *help = [[QYUserGuideViewController alloc] init];
    return help;
}

- (QYMainViewController *)mainViewController
{
    QYMainViewController *main = [[QYMainViewController alloc] init];
    return main;
}

@end
