//
//  QYMainViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYMainViewController.h"

#import "QYHomeViewController.h"
#import "QYMessageViewController.h"
#import "QYAboutMeViewController.h"
#import "QYPlazaViewController.h"
#import "QYMoreViewController.h"
#import "QYPlazaViewLayout.h"

@interface QYMainViewController ()

@end

@implementation QYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QYHomeViewController *homeVCtrl = [[QYHomeViewController alloc] initWithStyle:UITableViewStyleGrouped];
 
    QYMessageViewController *messageVCtrl = [[QYMessageViewController alloc] init];
    
    QYAboutMeViewController *aboutMeVCtrl = [[QYAboutMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    QYPlazaViewController *plazaVCtrl = [[QYPlazaViewController alloc] initWithCollectionViewLayout:[[QYPlazaViewLayout alloc] init]];
    
    QYMoreViewController *moreVCtrl = [[QYMoreViewController alloc] init];
    
    NSArray *viewControllers = @[homeVCtrl,messageVCtrl,aboutMeVCtrl,plazaVCtrl,moreVCtrl];
    
    NSMutableArray *viewNavControlles = [[NSMutableArray alloc] initWithCapacity:5];
    for (UIViewController *vctrlItem in viewControllers) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vctrlItem];
        [viewNavControlles addObject:nav];
        [nav release];
    }
    self.viewControllers = viewNavControlles;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
