//
//  QYHomeTableViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYHomeViewController.h"
#import "QYPlaySound.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "XMLDictionary.h"
#import "QYEditStatusViewController.h"
#import "QYAboutMeViewController.h"
#import "QYStatusTableViewCell.h"
#import "NSString+FrameHeight.h"
#import "QYWBDataBaseEngine.h"

@interface QYHomeViewController ()<QYStatusTableViewCellDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, assign) CGFloat stImageHeight;
@end

@implementation QYHomeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tabBarItem  initWithTitle:@"首页"
                                  image:[UIImage imageNamed:@"tabbar_home"]
                          selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        self.statusList = [[QYWBDataBaseEngine shareInstance] queryTimeLinesFromDataBase];
        if (nil == _statusList) {
            [self onRefreshControl:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.backgroundColor = [UIColor clearColor];
    [refreshControl addTarget:self action:@selector(onRefreshControl:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [refreshControl release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_pop_os7"] style:UIBarButtonItemStylePlain target:self action:@selector(onRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btnTitle setTitle:@"" forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnTitle.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btnTitle addTarget:self action:@selector(onTitleButtonTapped:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btnTitle;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_compose_os7"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - UINavigationBar button callback message

-(void) onTitleButtonTapped:(UIButton*)sender forEvent:(UIEvent*)event
{
    
}

- (void)onRightButtonItem:(UIBarButtonItem*)sender
{
    
}

- (void)onLeftButtonItem:(UIBarButtonItem*)sender
{
    QYEditStatusViewController *editStatusViewController = [[QYEditStatusViewController alloc] init];
    [self presentViewController:editStatusViewController animated:YES completion:nil];
    QYSafeRelease(editStatusViewController);
}

- (void)onRefreshControl:(UIRefreshControl*)refreshControl
{
    if (refreshControl != nil) {
        QYPlaySound *playSound = [[QYPlaySound alloc] initForPlayingSoundEffectWith:@"msgcome.wav"];
        [playSound play];
    }else
    {
        if (![SVProgressHUD isVisible]) {
            [SVProgressHUD show];
        }
    }
    [self requstTimelineFromSinaServer];
    [self requestUserInfoFromSinaServer];
}

- (void)requestUserInfoFromSinaServer
{
    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)requstTimelineFromSinaServer
{
    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.statusList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//这是一个全局变量
static CGFloat fontSize = 14.0f;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    用户头部信息高度
    CGFloat height4Header = 40.0;
    //    原创微博文本内容所占高度
    CGFloat statusTextHeight = 0.0;
    //    原创微博如果有图片的话， 图片所占的高度
    CGFloat statusImageViewHeight = 0.0;
    //    转发微博文本内容所占高度
    CGFloat retweetStatusTextHeight = 0.0;
    
    NSDictionary *statusInfo = self.statusList[indexPath.section];
    
    NSString *content = [statusInfo objectForKey:@"text"];
    
    statusTextHeight = [content frameHeightWithFontSize:fontSize forViewWidth:310.0f];
    NSDictionary *retweetStatus = [statusInfo objectForKey:@"retweeted_status"];
    
    //    当retweetStatus为空的时候， 表示当前是一条原创微博
    if (nil == retweetStatus) {
        //      如果这条微博带的有图片，则计算图片的高度
        NSArray *picUrls = [statusInfo objectForKey:@"pic_urls"];
        if (picUrls.count == 1) {
            NSDictionary *dic = picUrls[0];
            NSString *strPicUrls = [dic objectForKey:@"thumbnail_pic"];
            CGSize imagSize =  [self downloadJpgImage:strPicUrls];
            statusImageViewHeight += imagSize.height;
        }else if(picUrls.count > 1)
        {
            int picLineCount = ceilf(picUrls.count / 3.0);
            statusImageViewHeight += (80 * picLineCount);
        }
    }else
    {
        NSString *retContent = [retweetStatus objectForKey:@"text"];
        retweetStatusTextHeight = [retContent frameHeightWithFontSize:fontSize forViewWidth:310.0f];
        NSArray *retPicUrls = [retweetStatus objectForKey:@"pic_urls"];
        if (retPicUrls.count == 1) {
            NSDictionary *dic = retPicUrls[0];
            NSString *strPicUrls = [dic objectForKey:@"thumbnail_pic"];
            CGSize imgSize = [self downloadJpgImage:strPicUrls];
            statusImageViewHeight += imgSize.height;
        }else if(retPicUrls.count > 1)
        {
            int picLineCount = ceilf(retPicUrls.count / 3.0);
            statusImageViewHeight += (80 * picLineCount);
        }
        
        
    }
    return (height4Header + statusTextHeight + statusImageViewHeight + retweetStatusTextHeight+20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"statusCell";
    QYStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[QYStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.cellData = self.statusList[indexPath.section];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35.0f)];
    footerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    footerView.layer.borderWidth = 0.5f;
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *retsweetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 2.5, 90, 30)];
    [retsweetBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet_os7"] forState:UIControlStateNormal];
    NSString *retweetButtonTitle =[NSString stringWithFormat:@"%@",[self.statusList[section] objectForKey:kStatusRepostsCount]];
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
    NSString *commentButtonTitle =[NSString stringWithFormat:@"%@",[self.statusList[section] objectForKey:kStatusCommentsCount]];
    [commentBtn setTitle: commentButtonTitle forState:UIControlStateNormal];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    commentBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [footerView addSubview:commentBtn];
    
    UIButton *attitudesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame) + 10,2.5,90,30)];
    [attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike_os7"] forState:UIControlStateNormal];
    NSString *attitudesButtonTitle =[NSString stringWithFormat:@"%@",[self.statusList[section] objectForKey:kStatusAttitudesCount]];
    [attitudesBtn setTitle: attitudesButtonTitle forState:UIControlStateNormal];
    [attitudesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [attitudesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    attitudesBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    attitudesBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [footerView addSubview:attitudesBtn];
    
    return footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

#pragma mark -
#pragma mark Function callback
- (void)onRetweetButtonTapped:(UIButton*)retweetButton
{
    
}

#pragma mark -
#pragma mark SinaWeiboRequestDelegate
//当从服务器请求数据，返回的响应头
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"Request data from sina server error:%@",error);
        return;
    }
    [SVProgressHUD dismissWithError:@"RevData"];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSURL *url = [NSURL URLWithString:request.url];
    NSString *indentifierUrl = [[url pathComponents] lastObject];
    if ([indentifierUrl isEqualToString:@"home_timeline.json"]) {
        self.statusList = [result objectForKey:@"statuses"];
        [[QYWBDataBaseEngine shareInstance] saveTimelinesToDataBase:self.statusList];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }else if ([indentifierUrl isEqualToString:@"show.json"]){
        self.currentUserInfo = (NSDictionary*)result;
        UIButton *navTitleBtn =(UIButton*)self.navigationItem.titleView;
        NSString *title  = [self.currentUserInfo objectForKey:@"screen_name"];
        [navTitleBtn setTitle:title forState:UIControlStateNormal];
        [navTitleBtn setTitle:title forState:UIControlStateHighlighted];
    }
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    [SVProgressHUD dismiss];
}

#pragma mark -
#pragma mark QYStatusTableViewCellDelegate
- (void)statusTableCell:(QYStatusTableViewCell*)cell AvatarImageViewDidSelected:(UIGestureRecognizer*) gestur
{
    QYAboutMeViewController *personViewController = [[QYAboutMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //    当这界面的出现的时候， 如果有tabbar，则隐藏
    personViewController.hidesBottomBarWhenPushed = YES;
    personViewController.bisHideTabbar  = YES;
    CGPoint currentPoint = [gestur locationInView:self.tableView];
    NSIndexPath *currentIndexpath = [self.tableView indexPathForRowAtPoint:currentPoint];
    NSDictionary *usrInfo = [self.statusList objectAtIndex:currentIndexpath.section];
    personViewController.mDicPersonInfo = [usrInfo objectForKey:@"user"];
    personViewController.userID =[NSString stringWithFormat:@"%@", [usrInfo objectForKey:@"id"]];
    personViewController.mUserTimeLines = [NSArray arrayWithObject:usrInfo];
    [self.navigationController pushViewController:personViewController animated:YES];
}

- (void)statusTableCell:(QYStatusTableViewCell*)cell StatusImageViewDidSelected:(UIGestureRecognizer*) gesture
{
    
    NSString *originalPic = [cell.cellData objectForKey:@"original_pic"];
    if (originalPic != nil) {
        [self showFullViewWithName:originalPic];
    }
}

- (void)statusTableCell:(QYStatusTableViewCell *)cell RetStatusImageViewDidSelected:(UIGestureRecognizer*) gesture
{
    NSDictionary *currentStatus = [cell.cellData objectForKey:@"retweeted_status"];
    NSString *originalPic = [currentStatus objectForKey:@"original_pic"];
    if (originalPic != nil) {
        [self showFullViewWithName:originalPic];
    }
}

-(void)showFullViewWithName:(NSString*)imageName
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.tag = 3333;
    imageView.multipleTouchEnabled = YES;
    imageView.userInteractionEnabled = YES;
    NSData *imagData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageName]];
    UIImage *image = [UIImage imageWithData:imagData];
    imageView.image = image;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFullImageViewTapped:)];
    [imageView addGestureRecognizer:tapGesture];
    
    UIScrollView *picImageBgView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    picImageBgView.delegate = self;
    picImageBgView.multipleTouchEnabled = YES;
    picImageBgView.contentSize = image.size;
    picImageBgView.backgroundColor = [UIColor blackColor];
    picImageBgView.minimumZoomScale = 0.5f;
    picImageBgView.maximumZoomScale = 3.0f;
    [picImageBgView addSubview:imageView];
    [window addSubview:picImageBgView];
    
    window.userInteractionEnabled = YES;
    window.multipleTouchEnabled = YES;
}

- (void)onFullImageViewTapped:(UITapGestureRecognizer*)gestureRecongnizer
{
    [UIView animateWithDuration:2.25f animations:^{
        [gestureRecongnizer.view.superview removeFromSuperview];
        
    }];
//    之前认为是window如果不设置userInteractionEnabled为NO，为截取事件，所以会导至事件
//    丢失，但实际情况是不能设置这个值， 因为如果设置为NO，那么事件将传递不出去，所以将此两行
//    代码注释
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.userInteractionEnabled = NO;
//    window.multipleTouchEnabled = NO;
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return [scrollView viewWithTag:3333];
}


#pragma mark -
#pragma mark JPG格式的图片 根据图片部份数据得到图片的size
- (CGSize)downloadJpgImage:(NSString*)strUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [self jpgImageSizeWithHeaderData:data];
}

- (CGSize)jpgImageSizeWithHeaderData:(NSData *)data
{
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
