//
//  QYHomeTableViewController.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYHomeViewController : UITableViewController<SinaWeiboRequestDelegate>

@property (nonatomic, copy) NSArray *statusList;
@property (nonatomic, retain) NSDictionary *currentUserInfo;
@end
