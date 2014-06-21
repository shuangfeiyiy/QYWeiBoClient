//
//  QYPlazaViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYPlazaViewController.h"

#define  FOUR_CELL_IDENTIFIER   @"CollectionViewCellSectionFour"
#define  THREE_CELL_IDENTIFIER  @"CollectionViewCellSectionThree"
#define  TWO_CELL_IDENTIFIER    @"CollectionViewCellSectionTwo"
#define  ONE_CELL_IDENTIFIER    @"CollectionViewCellSectionOne"


typedef enum  {
    kPNCollectionViewCellSectionOne,
    kPNCollectionViewCellSectionTwo,
    kPNCollectionViewCellSectionThree,
    kPNCollectionViewCellSectionFour,
    kPNCollectionViewCellSectionNumbers
} CollectionSectionStyle;


@interface QYPlazaViewController ()

@end

@implementation QYPlazaViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.tabBarItem initWithTitle:@"广场"
                                 image:[UIImage imageNamed:@"tabbar_discover"]
                         selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
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

@end
