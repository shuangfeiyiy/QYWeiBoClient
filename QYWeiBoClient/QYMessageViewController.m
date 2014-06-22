//
//  QYMessageTableViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYMessageViewController.h"
#import "UIImageView+WebCache.h"
#import "QYMessageViewCell.h"

@interface QYMessageViewController ()<SinaWeiboRequestDelegate>
//固定的单元格信息的文本内容
@property (nonatomic, retain) NSMutableArray *messages;
//固定单元格头像内容
@property (nonatomic, retain) NSMutableArray *mImagesName;
//真正的双向关注的微博信息内容
@property (nonatomic, retain) NSArray *bilTimelineList;
@end

@implementation QYMessageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tabBarItem initWithTitle:@"消息"
                                 image:[UIImage imageNamed:@"tabbar_message_center"]
                         selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *msgs = @[@"提到我的",@"评论",@"赞",@"新浪新闻",@"未关注人私信"];
    self.messages = [msgs mutableCopy];
    
    NSArray *images = @[@"messagescenter_at_os7",@"messagescenter_comments_os7",@"messagescenter_good_os7",@"messagescenter_at_os7",@"messagescenter_at_os7"];
    self.mImagesName = [images mutableCopy];
    [self requestDataFromSinaServer];
}

- (void)requestDataFromSinaServer
{
    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
    [sinaweibo requestWithURL:@"statuses/bilateral_timeline.json"
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    单元格总数为：固定的单元格数＋双向关注的微博数目
    return self.bilTimelineList.count + self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYSmartTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        {
            cell = [QYSmartTableViewCell cellForTableViewWithIdentifer:tableView withCellStyle:UITableViewCellStyleDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:self.mImagesName[indexPath.row]];
            cell.textLabel.text = self.messages[indexPath.row];
            
        }
            break;
        default:
            cell = [QYMessageViewCell cellForTableViewWithIdentifer:tableView withCellStyle:UITableViewCellStyleSubtitle];
            cell.imageView.bounds = CGRectMake(0, 0, 50, 50);
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row < self.bilTimelineList.count) {
                NSDictionary *userInfo = self.bilTimelineList[indexPath.row][kStatusUserInfo];
                NSURL *url = [NSURL URLWithString:userInfo[kUserAvatarLarge]];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                cell.imageView.image = image;
/*
//                异步加载， 或者自己使用GCD实现
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSError * error;
//                    NSData * data = [NSData dataWithContentsOfURL:url];
//                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//                    if (data != nil) {
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            cell.imageView.image = image;
//                        });
//                    } else {
//                        NSLog(@"error when download:%@", error);
//                    }
//                });
//
                
//                异步加载，使用SDWebImage
//                [cell.imageView setImageWithURL:url];
*/
                cell.textLabel.text = userInfo[kUserInfoScreenName];
                cell.detailTextLabel.text = self.bilTimelineList[indexPath.row][kStatusText];
            }
            
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

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
    self.bilTimelineList = [result objectForKey:@"statuses"];
    [self.tableView reloadData];
}


@end
