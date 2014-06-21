//
//  QYDraftsViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-21.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYDraftsViewController.h"
#import "QYWBDataBaseEngine.h"
#import "QYSmartTableViewCell.h"
#import "QYEditStatusViewController.h"

@interface QYDraftsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *dratfStatus;
@end

@implementation QYDraftsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"草稿箱";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dratfStatus = [[QYWBDataBaseEngine shareInstance] queryTimeLinesFromDataBase];
    if (self.dratfStatus != nil && self.dratfStatus.count > 0) {
        UITableView *draftsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        draftsTableView.delegate = self;
        draftsTableView.dataSource = self;
        [self.view addSubview:draftsTableView];
        [draftsTableView release];
    }
}

#pragma mark - 
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dratfStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYSmartTableViewCell *cell = [QYSmartTableViewCell cellForTableViewWithIdentifer:tableView];
    cell.textLabel.text = [self.dratfStatus[indexPath.row] objectForKey:kStatusText];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYEditStatusViewController *editStatusVCTrl = [[QYEditStatusViewController alloc] init];
    editStatusVCTrl.mDicStatus = self.dratfStatus[indexPath.row];
    [self.navigationController pushViewController:editStatusVCTrl animated:YES];
    QYSafeRelease(editStatusVCTrl);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
