//
//  QYWBDataBaseEngine.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-20.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYWBDataBaseEngine : NSObject
//由于考虑数据库的使用，一个对象就可以满足需求， 所以声明一个单例方法
+ (instancetype)shareInstance;

//将单条微博数据保存到数据库
- (void)saveStatusToDataBase:(NSDictionary*)dicStatus;

//将获取到的所有微博信息保存到数据库
- (void)saveTimelinesToDataBase:(NSArray*)timeLines;

//将用户信息保存到数据库
- (void)saveUserInfoToDataBase:(NSDictionary *)dicUserInfo withStatusID:(NSString*)statusID;

//草稿箱的数据
- (void)saveTempStatusToDrafts:(NSDictionary*)temStatus;

//从数据库里查询微博信息
- (NSArray*)queryTimeLinesFromDataBase;

//从数据库里查询用户信息
- (NSArray*)queryTempStatusFromDataBase;
@end
