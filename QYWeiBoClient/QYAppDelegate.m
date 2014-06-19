//
//  QYAppDelegate.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYAppDelegate.h"
#import "QYViewControllerManager.h"
#import "QYSinaWeiboDelegate.h"

@implementation QYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLaunchStatus];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    QYSinaWeiboDelegate *sinaDelegate = [[QYSinaWeiboDelegate alloc] init];
    
    _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:sinaDelegate];

    NSDictionary *sinaweiboInfo = [NSUD objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    if ([NSUD boolForKey:@"firstLaunch"]) {
        [QYViewControllerManager presentQYController:QYControllerTypeUserGuideView];
    }else
    {
        if (YES) {
            [QYViewControllerManager presentQYController:QYControllerTypeMainView];
        }else
        {
            [QYViewControllerManager presentQYController:QYControllerTypeLoginView];
        }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaWeibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaWeibo handleOpenURL:url];
}

- (void)initLaunchStatus
{
    if (![NSUD boolForKey:@"everLaunched"]) {
        [NSUD setBool:YES forKey:@"everLaunched"];
        [NSUD setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [NSUD setBool:NO forKey:@"firstLaunch"];
    }
    [NSUD synchronize];
}
@end
