//
//  QYViewControllerManager.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QYViewControllerType) {
    QYControllerTypeUserGuideView,
    QYControllerTypeLoginView,
    QYControllerTypeMainView
};

@interface QYViewControllerManager : NSObject

+ (void)presentQYController:(QYViewControllerType)controllerType;
@end
