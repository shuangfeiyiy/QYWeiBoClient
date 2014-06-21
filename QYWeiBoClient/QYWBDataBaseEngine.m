//
//  QYWBDataBaseEngine.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-20.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYWBDataBaseEngine.h"
#import "FMDatabase.h"

@interface QYWBDataBaseEngine ()

@property (nonatomic, retain) FMDatabase *mDb;

@end

@implementation QYWBDataBaseEngine

+ (instancetype)shareInstance
{
    static QYWBDataBaseEngine *dbEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbEngine = [[self alloc] init];
    });
    return dbEngine;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *dbName = [NSString stringWithFormat:@"%@.sqlite",kPNWeiBoDataBaseName];
        NSString *dbPath = [self copyFile2Documents:dbName];
        NSLog(@"Databas path is :%@",dbPath);
        self.mDb = [FMDatabase databaseWithPath:dbPath] ;
        if (![self.mDb open]) {
            NSLog(@"open %@ error! error msg is:%@",dbPath,[self.mDb lastErrorMessage]);
        }

    }
    return self;
}

//将数据库文件从资源库剪切到Documents目录，由于在沙盒里只有Documents目录是可读写的
-(NSString*) copyFile2Documents:(NSString*)fileName
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//  得到消息盒的Document目录
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
//  将数据库文件名， 追加到目录后面，stringByAppendingPathComponent自动加上目录分隔符
    NSString*destPath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
//  如果目标目录也就是(Documents)目录没有数据库文件的时候，才会复制一份，否则不复制
    if(![fileManager fileExistsAtPath:destPath]){
        NSString* sourcePath =[[NSBundle mainBundle] pathForResource:kPNWeiBoDataBaseName ofType:@"sqlite"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
    }
    return destPath;
}

//将单条微博数据保存到数据库
- (void)saveStatusToDataBase:(NSDictionary*)dicStatus
{
    NSString *tableName = @"T_STATUS";
    NSString *oneSpace = @" ";
    NSMutableString *sql = [[NSMutableString alloc] initWithString:@"INSERT INTO"];
    [sql appendString:oneSpace];
    [sql appendString:tableName];
//  对于第一个id，我们直接赋值是null，这样子， sqlite数据库会将自动计数
    [sql appendString:@"(id,status_id,created_at,text,source,thumbnail_pic,\
     original_pic,user_id,retweeted_status_id,reposts_count,\
                        comments_count,attitudes_count) VALUES \
                        (null,?,?,?,?,?,?,?,?,?,?,?)"];

    BOOL isOK = [self.mDb executeUpdate:sql,
                 [dicStatus objectForKey:kStatusID],
                 [dicStatus objectForKey:kStatusCreateTime],
                 [dicStatus objectForKey:kStatusText],
                 [dicStatus objectForKey:kStatusSource],
                 [dicStatus objectForKey:kStatusThumbnailPic],
                 [dicStatus objectForKey:kStatusOriginalPic],
                 [[dicStatus objectForKey:kStatusUserInfo] objectForKey:kUserID],
                 [[dicStatus objectForKey:kStatusRetweetStatus] objectForKey:kStatusID],
                 [dicStatus objectForKey:kStatusRepostsCount],
                 [dicStatus objectForKey:kStatusCommentsCount],
                 [dicStatus objectForKey:kStatusAttitudesCount]];
    if (!isOK) {
        NSLog(@"save status to db failed.ERROR:%@",[self.mDb lastErrorMessage]);
        return;
    }
    
    [self saveUserInfoToDataBase:[dicStatus objectForKey:kStatusUserInfo] withStatusID:[dicStatus objectForKey:kStatusID]];
    //如果当前微博信息有转发微博，需要递归一次，将转发微博的信息也保存到数据库
    NSDictionary *dicRetweetStatus = [dicStatus objectForKey:kStatusRetweetStatus];
    if (dicRetweetStatus != nil) {
//        这是一种递归调用，递归调用一定有出口条件
        [self saveStatusToDataBase:dicRetweetStatus];
    }else
    {
        NSLog(@"Warrning:save data parame is emporty");
    }

}

- (void)saveTimelinesToDataBase:(NSArray*)timeLines
{
    for (NSDictionary *statusInfo in timeLines) {
        [self saveStatusToDataBase:statusInfo];
    }
}

#pragma mark - 将用户信息保存到数据库
- (void)saveUserInfoToDataBase:(NSDictionary *)dicUserInfo withStatusID:(NSString*)statusID
{
//    防御式编程，确保传入的参数是合法
    if (dicUserInfo != nil) {
        NSString *sql = @"INSERT INTO T_USER \
        (id,user_id,screen_name,name,status_id,avatar_large) \
        VALUES (null,?,?,?,?,?)";
        
        BOOL isOK =  [self.mDb executeUpdate:sql,[dicUserInfo objectForKey:kUserID],
                      [dicUserInfo objectForKey:kUserInfoScreenName],
                      [dicUserInfo objectForKey:kUserInfoName],
                      statusID,
                      [dicUserInfo objectForKey:kUserAvatarLarge]];
        if (!isOK) {
            NSLog(@"save user info to db failed.ERROR:%@",[self.mDb lastErrorMessage]);
            return;
        }
    }
}

- (NSArray*)queryTimeLinesFromDataBase
{
    NSString *sql = @"SELECT status_id,created_at,text,source, thumbnail_pic,\
    original_pic,user_id,retweeted_status_id, reposts_count,comments_count,attitudes_count\
    FROM t_status \
    where created_at < ? limit 20";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    FMResultSet *resultSet = [self.mDb executeQuery:sql,currentDate];
    NSMutableArray *arrayRet = [[NSMutableArray alloc] initWithCapacity:20];
    while ([resultSet next]) {
        NSDictionary *userInfo = [self queryUserInfoFromDataBase:[resultSet objectForColumnIndex:6]];
        if (nil == userInfo) {
            return nil;
        }
        NSDictionary *statusInfo = [self queryStatusFromDataBase:[resultSet objectForColumnIndex:7]];
//      如果有转发微博，则构建。
        if (statusInfo != nil) {
            [arrayRet addObject:@{kStatusID: [resultSet objectForColumnIndex:0],
                                  kStatusCreateTime : [resultSet objectForColumnIndex:1],
                                  kStatusText : [resultSet objectForColumnIndex:2],
                                  kStatusSource : [resultSet objectForColumnIndex:3],
                                  kStatusThumbnailPic : [resultSet objectForColumnIndex:4],
                                  kStatusOriginalPic : [resultSet objectForColumnIndex:5],
                                  kStatusUserInfo : userInfo,
                                  kStatusRetweetStatus : statusInfo,
                                  }];
        }else
        {
            [arrayRet addObject:@{kStatusID: [resultSet objectForColumnIndex:0],
                                  kStatusCreateTime : [resultSet objectForColumnIndex:1],
                                  kStatusText : [resultSet objectForColumnIndex:2],
                                  kStatusSource : [resultSet objectForColumnIndex:3],
                                  kStatusThumbnailPic : [resultSet objectForColumnIndex:4],
                                  kStatusOriginalPic : [resultSet objectForColumnIndex:5],
                                  kStatusUserInfo : userInfo,
                                  }];
            
        }
        
    }
    return arrayRet;
}


- (NSDictionary*)queryUserInfoFromDataBase:(NSString*)userID
{
    NSString *sql = @"SELECT user_id,screen_name,name,avatar_large FROM t_user where user_id = ?";
    FMResultSet *userInfo = [self.mDb executeQuery:sql,userID];
    NSDictionary *decRet= nil;
    while ([userInfo next]) {
        decRet = @{kUserID: [userInfo objectForColumnIndex:0],
                   kUserInfoScreenName:[userInfo objectForColumnIndex:1],
                   kUserInfoName:[userInfo objectForColumnIndex:2],
                   kUserAvatarLarge:[userInfo objectForColumnIndex:3]};
    }
    return decRet;
}

- (NSDictionary*)queryStatusFromDataBase:(NSString*)statusID
{
    NSString *sql = @"SELECT created_at,text,source,thumbnail_pic,original_pic\
    reposts_count,comments_count,attitudes_count FROM t_status where status_id = ?";
    FMResultSet *statusInfo = [self.mDb executeQuery:sql,statusID];
    NSDictionary *dicStatus = nil;
    while ([statusInfo next]) {
        dicStatus = @{kStatusID: statusID,
                      kStatusCreateTime : [statusInfo objectForColumnIndex:0],
                      kStatusText: [statusInfo objectForColumnIndex:1],
                      kStatusSource : [statusInfo objectForColumnIndex:2],
                      kStatusThumbnailPic : [statusInfo objectForColumnIndex:3],
                      kStatusOriginalPic : [statusInfo objectForColumnIndex:4]};
        
    }
    return dicStatus;
}

@end
