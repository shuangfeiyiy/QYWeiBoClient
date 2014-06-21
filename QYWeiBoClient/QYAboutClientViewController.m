//
//  QYAboutClientViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-21.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYAboutClientViewController.h"

@interface QYAboutClientViewController ()

@end

@implementation QYAboutClientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)onBtnAction:(UIButton*)sender {
    NSString *strUrl = nil;
    if (sender.tag == 0) {
        //   个人用户电话
        strUrl = @"tel://4000460460";
    }else if(sender.tag == 1)
    {
        //   企业用户电话
        strUrl = @"tel://4000480480";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}

@end
