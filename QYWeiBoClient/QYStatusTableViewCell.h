//
//  QYStatusTableViewCell.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-17.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYStatusTableViewCell;
@protocol QYStatusTableViewCellDelegate <NSObject>

- (void)statusTableCell:(QYStatusTableViewCell*)cell AvatarImageViewDidSelected:(UIGestureRecognizer*) gesture;
- (void)statusTableCell:(QYStatusTableViewCell*)cell StatusImageViewDidSelected:(UIGestureRecognizer*) gesture;
- (void)statusTableCell:(QYStatusTableViewCell *)cell RetStatusImageViewDidSelected:(UIGestureRecognizer*) gesture;

@end

@interface QYStatusTableViewCell : UITableViewCell

//显示微博单元头部内容主要是发布微博博主的头像，名字，发布微博时间间及微博来源。
@property (retain, nonatomic)  UIImageView *avatarImage;
@property (retain, nonatomic)  UILabel *nameLabel;
@property (retain, nonatomic)  UILabel *createTimeLabel;
@property (retain, nonatomic)  UILabel *sourceLabel;


@property (retain, nonatomic)  UILabel  *labelStatus;
@property (retain, nonatomic)  UIView * stImageViewBg;

@property (retain, nonatomic) UILabel *labelRetweetStatus;
@property (retain, nonatomic) UIView *retStImageViewBg;

//微博正文及转发微博的背景视图，主要是为了显示布局才使用这个视图
@property (retain, nonatomic)  UIView *statusBackgroundView;
//微博正文内容
@property (retain, nonatomic)  UITextView *textTextView;
//微博正文附加的图片视图，注意不是转发微博的附加图片
@property (retain, nonatomic)  UIImageView *picImageView;
//微博正文附加的图片，同步从服务器上获取这个二进制数据，然后创建此图片
@property (retain,nonatomic) UIImage *weiboImage;
//微博一个单元格显示所需要的全部数据， 由tabbleView所以在控制器在创建单元格的时候传进来
@property (nonatomic, retain) NSDictionary *cellData;
//转发微博附带图片视图
@property (nonatomic, retain) UIImageView *retweetPicImageView;
@property (nonatomic, assign) id<QYStatusTableViewCellDelegate> delegate;
@end
