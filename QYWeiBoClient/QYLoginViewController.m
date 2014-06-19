//
//  QYLoginViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYLoginViewController.h"

@interface QYLoginViewController ()

@end

@implementation QYLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)doLogin:(id)sender {
    
    [appDelegate.sinaWeibo logIn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [QYNSDC addObserver:self selector:@selector(onLoginNotification:) name:kPNNotificationNameLogin object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [QYNSDC removeObserver:self name:kPNNotificationNameLogin object:nil];
}


- (void)onLoginNotification:(NSNotification*)notification
{
    [QYViewControllerManager presentQYController:QYControllerTypeMainView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
