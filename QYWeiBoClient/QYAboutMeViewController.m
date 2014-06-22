//
//  QYAboutMeTableViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYAboutMeViewController.h"
#import "UIImageView+WebCache.h"
#import "XMLDictionary.h"
#import "QYStatusTableViewCell.h"
#import "QYEditStatusViewController.h"
#import "QYFriendViewController.h"

enum AboutMeSection {
    kNewStatuesInfoSection,
    kMoreStatuesSection,
    kPhotoSection,
    kPraiseInfoSection,
    kOtherInfoSection,
    kMyPersonalInfoSection,
    kAboutMeSectionNums
    
};

@interface QYAboutMeViewController ()


@end

@implementation QYAboutMeViewController
{
    UIView *detailUserInfoBgView;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"我";
        [self.tabBarItem initWithTitle:@"我"
                                 image:[UIImage imageNamed:@"tabbar_profile"]
                         selectedImage:[UIImage imageNamed:@"tabbar_profileselected"]];
        [self requestUserTimeLineFromSinaServer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.bisHideTabbar) {
        self.navigationController.navigationBarHidden = YES;
        //      根据tabbarcontroller取出homeViewController所在的导航控制器
        UINavigationController *nav =(UINavigationController*)self.tabBarController.viewControllers[0];
        //      为了不发生与homeViewController的相互依赖关系，这里采用KVC机制，将homeViewController里从网
        //        络获取的当前个人用户信息
        self.mDicPersonInfo = (NSDictionary*)[nav.topViewController   valueForKey:@"currentUserInfo"];
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        self.title = @"个人主页";
    }
    
    
    CGRect headFrame = CGRectMake(0, 0, 320, 255);
    UIView *headView = [[UIView alloc] initWithFrame:headFrame];
    headView.backgroundColor = [UIColor whiteColor];
    //  背景图片视图
    CGRect imageFrame = CGRectMake(0, -100, 320, 250);
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:imageFrame];
    imgview.image = [UIImage imageNamed:@"profile_cover_background@2x.jpg"];
    //  由于在imageView上会设置一些button,所以需要设置这个参数
    imgview.userInteractionEnabled = YES;
    [headView addSubview:imgview];
    self.tableView.tableHeaderView = headView;
    
    
    //    创建个人信息的图片显示
    UIImageView *avatarImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, 60, 60)];
    [avatarImageView setImageWithURL:[NSURL URLWithString:[self.mDicPersonInfo objectForKey:@"avatar_hd"]]];
    [headView addSubview:avatarImageView];
    [avatarImageView release];
    //    个人信息的名字
    UILabel *labelMeName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame)+20, avatarImageView.frame.origin.y + 95, 100, 30)];
    labelMeName.text = [self.mDicPersonInfo objectForKey:@"screen_name"];
    labelMeName.textColor = [UIColor whiteColor];
    labelMeName.font = [UIFont boldSystemFontOfSize:14.0f];
    [imgview addSubview:labelMeName];
    [labelMeName release];
    
    //    个人信息图片右边的两个button
    UIButton *buttonWrite = [self createButton:[UIImage imageNamed:@"userinfo_relationship_indicator_compose_os7"] Title:@"写微博" Frame: CGRectMake(CGRectGetMaxX(avatarImageView.frame)+15, 160, 100, 25)];
    [buttonWrite addTarget:self action:@selector(showEditStatusView:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonWrite];
    
    UIButton *buttonFriends = [self createButton:[UIImage imageNamed:@"userinfo_relationship_indicator_friends_os7"] Title:@"好友列表" Frame:CGRectMake(CGRectGetMaxX(buttonWrite.frame)+10, 160, 100, 25)];
    [buttonFriends setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 50)];
    [buttonFriends setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [buttonFriends addTarget:self action:@selector(showFriendList:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonFriends];
    
    UIButton *buttonDesp = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(buttonFriends.frame)+5, 300, 20)];
    buttonDesp.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [buttonDesp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonDesp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    NSString *title = [self.mDicPersonInfo objectForKey:@"verified_reason"];
    if (nil == title || title.length == 0) {
        title = [self.mDicPersonInfo objectForKey:@"description"];
    }
    [buttonDesp setTitle:title forState:UIControlStateNormal];
    [headView addSubview:buttonDesp];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(buttonDesp.frame)+5, 320, 1)];
    lineImageView.image = [UIImage imageNamed:@"settings_statistic_form_background_line"];
    [headView addSubview:lineImageView];
    
    detailUserInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineImageView.frame), 320, 40)];
    detailUserInfoBgView.backgroundColor = [UIColor whiteColor];
    NSString *statusCount = [NSString stringWithFormat:@" %@\n微博",[self.mDicPersonInfo objectForKey:@"statuses_count"]];
    NSString *friendsCount = [NSString stringWithFormat:@" %@\n关注",[self.mDicPersonInfo objectForKey:@"friends_count"]];
    NSString *followersCount = [NSString stringWithFormat:@" %@\n粉丝",[self.mDicPersonInfo objectForKey:@"followers_count"]];
    NSArray *detailUserInfoTitles = @[@"详细\n资料",statusCount,friendsCount,followersCount,@"更多"];
    for (int i = 0 ; i < detailUserInfoTitles.count; i++) {
        NSString *title = detailUserInfoTitles[i];
        [self createDetailUserInfoItem:title Frame:CGRectMake(i * 64, 0, 64, 40)];
    }
    
    [headView addSubview:detailUserInfoBgView];

}
- (void)createDetailUserInfoItem:(NSString*)title Frame:(CGRect)frame
{
    UIButton * userDetailBtn = [[UIButton alloc] initWithFrame:frame];
    userDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    userDetailBtn.titleLabel.numberOfLines = 2;
    userDetailBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [userDetailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userDetailBtn setTitle:title forState:UIControlStateNormal];
    [userDetailBtn setTitle:title forState:UIControlStateHighlighted];
    [detailUserInfoBgView addSubview:userDetailBtn];
    [userDetailBtn release];
}

- (void)showEditStatusView:(UIButton*)sender
{
    QYEditStatusViewController *writeStatusViewController = [[QYEditStatusViewController alloc] init];
    writeStatusViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeStatusViewController animated:YES];
    QYSafeRelease(writeStatusViewController);
}

- (void)showFriendList:(UIButton*)sender
{
    QYFriendViewController *friendListViewController = [[QYFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
    friendListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendListViewController animated:YES];
    QYSafeRelease(friendListViewController);
}

- (UIButton*)createButton:(UIImage*)image Title:(NSString*)title Frame:(CGRect)frame
{
    UIButton *retButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retButton.frame = frame;
    retButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    retButton.layer.borderWidth = 1.0f;
    retButton.layer.cornerRadius = 3.0f;
    [retButton setTitle:title forState:UIControlStateNormal];
    [retButton setTitle:title forState:UIControlStateHighlighted];
    [retButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [retButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [retButton setImage:image forState:UIControlStateNormal];
    [retButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 60)];
    [retButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    retButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    retButton.backgroundColor = [UIColor whiteColor];
    return retButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return kAboutMeSectionNums;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int retRowNumber = 0;
    switch (section) {
        case kNewStatuesInfoSection:
        case kMoreStatuesSection:
        case kPhotoSection:
        case kMyPersonalInfoSection:
            retRowNumber = 1;
            break;
        case kPraiseInfoSection:
        case kOtherInfoSection:
            retRowNumber = 2;
            break;
        default:
            break;
    }
    return retRowNumber;
}

static CGFloat fontSize = 14.0f;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kNewStatuesInfoSection:
        {
            return [self heightForNewStatuesCell:indexPath];
        }
            break;
            
        default:
            break;
    }
    return 57.0;
}

- (CGFloat)heightForNewStatuesCell:(NSIndexPath*)indexPath
{
    CGFloat height4Header = 40.0;
    //    原创微博文本内容所占高度
    CGFloat statusTextHeight = 0.0;
    //    原创微博如果有图片的话， 图片所占的高度
    CGFloat statusImageViewHeight = 0.0;
    //    转发微博文本内容所占高度
    CGFloat retweetStatusTextHeight = 0.0;
    
    NSDictionary *statusInfo = self.mUserTimeLines[0];
    
    NSString *content = [statusInfo objectForKey:@"text"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [content sizeWithAttributes:attributes];
    statusTextHeight =ceilf(size.width / size.height + 15.0f);
    NSDictionary *retweetStatus = [statusInfo objectForKey:@"retweeted_status"];
    
    //    当retweetStatus为空的时候， 表示当前是一条原创微博
    if (nil == retweetStatus) {
        //      如果这条微博带的有图片，则计算图片的高度
        NSArray *picUrls = [statusInfo objectForKey:@"pic_urls"];
        if (picUrls.count == 1) {
            NSDictionary *dic = picUrls[0];
            NSString *strPicUrls = [dic objectForKey:@"thumbnail_pic"];
            UIImage *weiboImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
            statusImageViewHeight += weiboImage.size.height;
        }else if(picUrls.count > 1)
        {
            int picLineCount = ceilf(picUrls.count / 3.0);
            statusImageViewHeight += (80 * picLineCount);
        }
    }else
    {
        NSString *retContent = [retweetStatus objectForKey:@"text"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        CGSize size = [retContent sizeWithAttributes:attributes];
        retweetStatusTextHeight = ceilf(size.width / size.height + 15.0f);
        
        NSArray *retPicUrls = [retweetStatus objectForKey:@"pic_urls"];
        if (retPicUrls.count == 1) {
            NSDictionary *dic = retPicUrls[0];
            NSString *strPicUrls = [dic objectForKey:@"thumbnail_pic"];
            UIImage *weiboImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
            statusImageViewHeight += weiboImage.size.height;
        }else if(retPicUrls.count > 1)
        {
            int picLineCount = ceilf(retPicUrls.count / 3.0);
            statusImageViewHeight += (80 * picLineCount);
        }
        
        
    }
    return (height4Header + statusTextHeight + statusImageViewHeight + retweetStatusTextHeight + 20);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"statusCell";
    
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (normalCell == nil) {
        normalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.section) {
        case kNewStatuesInfoSection:
        {
            QYStatusTableViewCell *statusCell = [[QYStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            statusCell.cellData = self.mUserTimeLines[0];
            return statusCell;
        }
            break;
            
        default:
            break;
    }
    
    return  normalCell;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kNewStatuesInfoSection) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35.0f)];
        footerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        footerView.layer.borderWidth = 0.5f;
        footerView.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *currrentStatusInfo = self.mUserTimeLines[0];
        UIButton *retsweetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 2.5, 90, 30)];
        [retsweetBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet_os7"] forState:UIControlStateNormal];
        NSString *retweetButtonTitle =[NSString stringWithFormat:@"%@",[currrentStatusInfo objectForKey:kStatusRepostsCount]];
        [retsweetBtn setTitle: retweetButtonTitle forState:UIControlStateNormal];
        [retsweetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
        [retsweetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
        retsweetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        retsweetBtn.titleLabel.textColor = [UIColor darkGrayColor];
        retsweetBtn.tag = section;
        [retsweetBtn addTarget:self action:@selector(onRetweetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:retsweetBtn];
        
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(retsweetBtn.frame)+10, 2.5, 90, 30)];
        [commentBtn setImage:[UIImage imageNamed:@"timeline_icon_comment_os7"] forState:UIControlStateNormal];
        NSString *commentButtonTitle =[NSString stringWithFormat:@"%@",[currrentStatusInfo objectForKey:kStatusCommentsCount]];
        [commentBtn setTitle: commentButtonTitle forState:UIControlStateNormal];
        [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
        [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        commentBtn.titleLabel.textColor = [UIColor darkGrayColor];
        [footerView addSubview:commentBtn];
        
        UIButton *attitudesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame) + 10,2.5,90,30)];
        [attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike_os7"] forState:UIControlStateNormal];
        NSString *attitudesButtonTitle =[NSString stringWithFormat:@"%@",[currrentStatusInfo objectForKey:kStatusAttitudesCount]];
        [attitudesBtn setTitle: attitudesButtonTitle forState:UIControlStateNormal];
        [attitudesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
        [attitudesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        attitudesBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        attitudesBtn.titleLabel.textColor = [UIColor darkGrayColor];
        [footerView addSubview:attitudesBtn];
        return footerView;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case kNewStatuesInfoSection:
            return 35.0f;
            break;
            
        default:
            break;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
#pragma mark -
#pragma mark Request data from server
//根据用户id获取当前用户发布的微博
- (void)requestUserTimeLineFromSinaServer
{
    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
    if (self.userID == nil) {
        self.userID = sinaweibo.userID;
    }
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:self.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)onRetweetButtonTapped:(UIButton*)sender
{
    
}
#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s:%@",__func__,response);
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    NSLog(@"%s",__func__);
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s:%@",__func__,error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%s,%@",__func__,result);
    self.fullTimeLines = [result objectForKey:@"statuses"];
    if (self.mUserTimeLines == nil) {
        self.mUserTimeLines =[NSArray arrayWithObject:[self.fullTimeLines objectAtIndex:0]];
        [self.tableView reloadData];
    }
}

@end
