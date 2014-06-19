//
//  QYAboutMeTableViewController.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAboutMeViewController : UITableViewController<SinaWeiboRequestDelegate>
//个人信息数据
@property (nonatomic, retain) NSDictionary *mDicPersonInfo;
//用于判断“关于我的这个界面“是什么条件下创建的：1､直接点击的tabbar NO 2、微博界面点击图标创建 YES
@property (nonatomic, assign) BOOL bisHideTabbar;

@property (nonatomic, retain) NSArray *mUserTimeLines;
@property (nonatomic, retain) NSArray *fullTimeLines;
@property (nonatomic, retain)NSString *userID;
@end
