//
//  QYStatusTableViewCell.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-17.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYStatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XMLDictionary.h"
#import "NSString+FrameHeight.h"

typedef NS_ENUM(NSUInteger, QYCellStatusImageViewType) {
    kCellStatusImageView,
    kCellReweetStatusImageView
};

@implementation QYStatusTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat fontSize = 14.0f;
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        //因为UIImageView默认情况下是不能交互， 也就是默认情况下放在其上的控件不能点击，手势也不起作用
        self.avatarImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarImageViewTapped:)];
        [self.avatarImage addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_avatarImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.contentView addSubview:_nameLabel];
        
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _createTimeLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.contentView addSubview:_createTimeLabel];
        
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.contentView addSubview:_sourceLabel];
        
        
        _labelStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        self.labelStatus.font = [UIFont systemFontOfSize:fontSize];
        self.labelStatus.numberOfLines = 0;
        [self.contentView addSubview:_labelStatus];
        
        _stImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_stImageViewBg];
        
        _labelRetweetStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelRetweetStatus.font = [UIFont systemFontOfSize:fontSize];
        _labelRetweetStatus.numberOfLines = 0;
        _labelRetweetStatus.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_labelRetweetStatus];
        
        _retStImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_retStImageViewBg];
    }
    return self;
}

//由于cell复用的时候， init方法不会再次调用， 所以之前设置的frame高度需要重新设置，否则会出现
//重复的问题。
- (void)restoreCellSubviewFrame
{
    self.labelStatus.frame = CGRectZero;
    self.labelRetweetStatus.frame = CGRectZero;
    self.stImageViewBg.frame = CGRectZero;
    self.retStImageViewBg.frame = CGRectZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    为了保障复用单元格的时候，界面不会出现重复，需要在重新布局前，将界面还原
    [self restoreCellSubviewFrame];
    CGFloat fontSize = 14.0f;
    NSDictionary *dicUserInfo = [self.cellData objectForKey:@"user"];
    NSDictionary *statusInfo = self.cellData;
    
    NSUInteger widthSpace = 5;

    NSString *strUrl = [dicUserInfo objectForKey:@"avatar_large"];
    [self.avatarImage setImageWithURL:[NSURL URLWithString:strUrl]];
    
    self.nameLabel.frame =  CGRectMake(CGRectGetMaxX(self.avatarImage.frame)+widthSpace, 2, 100, 20);
    self.nameLabel.text = [dicUserInfo objectForKey:@"screen_name"];
    
    self.createTimeLabel.frame =  CGRectMake(CGRectGetMaxX(self.avatarImage.frame)+widthSpace,CGRectGetHeight(self.nameLabel.frame)+ 2,100,20);
    NSString *strDate = [statusInfo objectForKey:@"created_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    NSTimeInterval interval = [dateFromString timeIntervalSinceNow];
    self.createTimeLabel.text = [NSString stringWithFormat:@"%d分钟之前",abs((int)interval/60)];
    
    
    self.sourceLabel.frame = CGRectMake(CGRectGetMaxX(self.createTimeLabel.frame)+widthSpace, CGRectGetHeight(self.nameLabel.frame)+2, 150, 20);
    self.sourceLabel.font = [UIFont systemFontOfSize:fontSize];
    NSString *xmlSourceString = [statusInfo objectForKey:@"source"];
    NSDictionary *dicSource = [NSDictionary  dictionaryWithXMLString:xmlSourceString];
    self.sourceLabel.text = [dicSource objectForKey:@"__text"];
    
    //    微博正文
    NSString *statusText = [statusInfo objectForKey:@"text"];
    self.labelStatus.text = statusText;
    CGFloat statusTextHight = [statusText frameHeightWithFontSize:fontSize forViewWidth:310.f];
    CGRect newFrame = CGRectMake(widthSpace, CGRectGetMaxY(self.sourceLabel.frame)+widthSpace, 310, statusTextHight);
    self.labelStatus.frame = newFrame;


    for (UIView *retView in [self.retStImageViewBg  subviews]) {
        [retView removeFromSuperview];
    }
    
    for (UIView *stView in [self.stImageViewBg subviews]) {
        [stView removeFromSuperview];
    }
    
    NSDictionary *retweetStatusInfo = [self.cellData objectForKey:@"retweeted_status"];
    //  当这条微博是一条转发微博
    if (retweetStatusInfo != nil) {
        //    转发微博正文
        NSString *statusText = [retweetStatusInfo objectForKey:@"text"];
        self.labelRetweetStatus.text = statusText;
        CGRect newFrame = CGRectMake(widthSpace, CGRectGetMaxY(self.labelStatus.frame)+widthSpace, 310, [statusText frameHeightWithFontSize:fontSize forViewWidth:310.0f]);
        self.labelRetweetStatus.frame = newFrame;
        
        [self layoutStatusImageView:kCellReweetStatusImageView];
        
    }else
    {
        [self layoutStatusImageView:kCellStatusImageView];
    }
}

- (void)layoutStatusImageView:(QYCellStatusImageViewType)type
{
    NSDictionary *statusInfo = nil;
    UIView *backGroundView = nil;
    UILabel *preLabel = nil;
    
    const  NSUInteger widthSpace = 5;
    NSUInteger statusImageWidth = 70.0f;
    NSUInteger statusImageHeight = 70.0f;
    switch (type) {
        case kCellStatusImageView:
        {
            statusInfo = self.cellData;
            backGroundView = self.stImageViewBg;
            preLabel = self.labelStatus;
        }
            break;
            case kCellReweetStatusImageView:
        {
            statusInfo = [self.cellData objectForKey:@"retweeted_status"];
            backGroundView = self.retStImageViewBg;
            preLabel = self.labelRetweetStatus;
        }
            break;
        default:
            break;
    }
    
    //   微博正文附带图片
    NSArray *statusPicUrls = [statusInfo objectForKey:@"pic_urls"];
    
    if (statusPicUrls.count > 1) {
        backGroundView.frame = CGRectMake(0, CGRectGetMaxY(preLabel.frame)+widthSpace, 310, 80 * ceilf(statusPicUrls.count /3.0f));
        for (int i = 0 ; i < statusPicUrls.count; i++) {
            UIImageView *stImgView = nil;
            if (statusPicUrls.count == 4) {
                stImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5+statusImageWidth*(i%2), statusImageHeight*ceil(i/2), statusImageWidth, statusImageHeight)];
            }else
            {
                stImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5+statusImageWidth*(i%3), statusImageHeight*ceil(i/3), statusImageWidth, statusImageHeight)];
            }
            
            NSString *strPicUrls = [statusPicUrls[i] objectForKey:@"thumbnail_pic"];
            [stImgView setImageWithURL:[NSURL URLWithString:strPicUrls]];
            [backGroundView addSubview:stImgView];
        }
    }else if (statusPicUrls.count == 1)
    {
        
        NSString *strPicUrls = [statusPicUrls[0] objectForKey:@"thumbnail_pic"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
        UIImageView *stImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, image.size.width, image.size.height)];
        [stImgView setImage:image];
        backGroundView.frame = CGRectMake(widthSpace, CGRectGetMaxY(preLabel.frame)+widthSpace, image.size.width, image.size.height);
        [backGroundView addSubview:stImgView];
    }

}

#pragma mark -
#pragma mark UITapGestureRecongnizer callback method
- (void)onAvatarImageViewTapped:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(statusTableCell:AvatarImageViewDidSelected:)]) {
        [self.delegate statusTableCell:self AvatarImageViewDidSelected:gesture];
    }
}

- (void)onRetImageViewTapped:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(statusTableCell:RetStatusImageViewDidSelected:)]) {
        [self.delegate statusTableCell:self RetStatusImageViewDidSelected:gesture];
    }
}
@end
