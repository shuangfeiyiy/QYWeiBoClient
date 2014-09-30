//
//  QYConstDefine.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#ifndef QYWeiBoClient_QYConstDefine_h
#define QYWeiBoClient_QYConstDefine_h

//此工程如果想要正常运行，需要先注册成为新浪的开发者，创建工程得到kAppKey和kAppSecret
//如果想要测试此工程，需要修改kAppKey 和 kAppSecret两个值为自己在新浪微博平台申请的值
#define kAppKey           @"4074510129"
#define kAppSecret        @"30dac3d5368fbdd37b8034e3431f5ba8"
#define kAppRedirectURI   @"https://api.weibo.com/oauth2/default.html"

//微博客户端所使用的数据库名字
static NSString * const kPNWeiBoDataBaseName = @"qy_weibo_client";

static NSString  * const kPNNotificationNameLogin = @"LoginNotification";
static NSString  * const kPNNotificationNameLogoff = @"LogoffNotification";

//解析微博所使用的关键字常量，也就是新浪服务器返回的数据由JSONKit解析后生成的字典关于微博信息的key值
static NSString * const kStatusCreateTime = @"created_at";
static NSString * const kStatusID = @"id";
static NSString * const kStatusMID = @"mid";
static NSString * const kStatusText = @"text";
static NSString * const kStatusSource = @"source";
static NSString * const kStatusThumbnailPic = @"thumbnail_pic";
static NSString * const kStatusOriginalPic = @"original_pic";
static NSString * const kStatusPicUrls = @"pic_urls";
static NSString * const kStatusRetweetStatus = @"retweeted_status";
static NSString * const kStatusUserInfo = @"user";
static NSString * const kStatusRetweetStatusID = @"retweeted_status_id";
static NSString * const kStatusRepostsCount = @"reposts_count";
static NSString * const kStatusCommentsCount = @"comments_count";
static NSString * const kStatusAttitudesCount = @"attitudes_count";

//解析微博用户数据所使用的关键字常量，也就是新浪服务器返回的数据由JSONKit解后生成的字典关于用户信息的Key值。
static NSString * const kUserInfoScreenName = @"screen_name";
static NSString * const kUserInfoName = @"name";
static NSString * const kUserAvatarLarge = @"avatar_large";
static NSString * const kUserAvatarHd = @"avatar_hd";
static NSString * const kUserID = @"id";
static NSString * const kUserDescription = @"description";
static NSString * const kUserVerifiedReson = @"verified_reason";
static NSString * const kUserFollowersCount = @"followers_count";
static NSString * const kUserStatusCount = @"statuses_count";
static NSString * const kUserFriendCount = @"friends_count";
static NSString * const kUserStatusInfo = @"status";
static NSString * const kUserStatuses = @"statuses";

//朋友列表常量
static NSString * const kFriendUser = @"users";
static NSString * const kFriendUserProfileImageUrl = @"profile_image_url";

#endif
