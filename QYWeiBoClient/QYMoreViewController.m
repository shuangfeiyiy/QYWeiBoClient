//
//  QYMoreTableViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYMoreViewController.h"

@interface QYMoreViewController ()
@property (nonatomic ,retain) NSDictionary *infos;
@end

@implementation QYMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tabBarItem initWithTitle:@"更多"
                                 image:[UIImage imageNamed:@"tabbar_more"]
                         selectedImage:[UIImage imageNamed:@"tabbar_more_selected"]];
         self.infos = @{@"0": @[@"草稿箱"],@"1":@[@"账号管理"],@"2":@[@"阅读模式",@"主题"],@"3":@[@"隐私设置",@"账号安全",@"设备管理"],@"4":@[@"官方微博",@"意见反馈",@"给我评分",@"新版本检测",@"关于"]};
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //
    [QYNSDC addObserver:self selector:@selector(onExitClientNotification:) name:kPNNotificationNameLogoff object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [QYNSDC removeObserver:self name:kPNNotificationNameLogoff object:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销此账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
    [alertView show];
    QYSafeRelease(alertView);
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //  如果是确定按纽按下
    if (buttonIndex == 1) {
        [appDelegate.sinaWeibo logOut];
    }
}

#pragma mark - Notification call back function

- (void)onExitClientNotification:(NSNotification*)notification
{
    
    [QYViewControllerManager  presentQYController:QYControllerTypeLoginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    int ret = 0;
    switch (section) {
        case 0:
        case 1:
            ret = 1;
            break;
        case 2:
            ret = 2;
            break;
        case 3:
            ret = 3;
            break;
        case 4:
            ret = 5;
            break;
        default:
            break;
    }
    return ret;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    cell.textLabel.text = [[self.infos objectForKey:key] objectAtIndex:indexPath.row];
    return cell;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        
        UIView *view  = [[UIView alloc] initWithFrame:CGRectZero];
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame = CGRectMake(0, 10, 320, 40);
        exitBtn.backgroundColor = [UIColor redColor];
        exitBtn.layer.cornerRadius = 2.0f;
        exitBtn.titleLabel.textColor = [UIColor whiteColor];
        exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [exitBtn setTitle:@"退出当前账号"  forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(onExitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:exitBtn];
        return view;
    }
    return nil;
}

- (void)onExitBtnTapped:(UIButton*)sender
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //主要是用于修改TableView section之间的间距
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 60;
    }
    return 5.0f;
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

@end
