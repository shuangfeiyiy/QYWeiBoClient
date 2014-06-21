//
//  QYPlazaViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-6.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYPlazaViewController.h"
#import "QYCollectionViewCellSectionFour.h"
#import "QYCollectionViewCellSectionThree.h"
#import "QYCollectionViewCellSectionTwo.h"
#import "QYCollectionViewCellSectionOne.h"

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
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSArray *sectionOneImages;
@property (nonatomic, retain) NSArray *sectionLabelNames;
@end

@implementation QYPlazaViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.tabBarItem initWithTitle:@"广场"
                                 image:[UIImage imageNamed:@"tabbar_discover"]
                         selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
        self.title = @"广场";
        self.sectionOneImages = @[@"contacts_findfriends_icon",@"messagescenter_comments_os7",@"contacts_findfriends_icon",@"messagescenter_comments_os7"];
        self.sectionLabelNames = @[@"扫一扫",@"找朋友",@"会员",@"周边"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *searbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searbar.placeholder = @"搜索";
    self.navigationItem.titleView = searbar;
    [self registerPNCustomCollectionViewCell];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)registerPNCustomCollectionViewCell
{
    [self.collectionView registerClass:[QYCollectionViewCellSectionFour class] forCellWithReuseIdentifier:FOUR_CELL_IDENTIFIER];
    
    [self.collectionView registerClass:[QYCollectionViewCellSectionThree class] forCellWithReuseIdentifier:THREE_CELL_IDENTIFIER];
    
    [self.collectionView registerClass:[QYCollectionViewCellSectionTwo class] forCellWithReuseIdentifier:TWO_CELL_IDENTIFIER];
    
    [self.collectionView registerClass:[QYCollectionViewCellSectionOne class] forCellWithReuseIdentifier:ONE_CELL_IDENTIFIER];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kPNCollectionViewCellSectionNumbers;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int ret = 0;
    switch (section) {
        case kPNCollectionViewCellSectionOne:
            ret = 4;
            break;
        case kPNCollectionViewCellSectionTwo:
            ret = 1;
            break;
        case kPNCollectionViewCellSectionThree :
            ret = 4;
            break;
        case kPNCollectionViewCellSectionFour:
            ret = 16;
            break;
        default:
            break;
    }
    return ret;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    switch (indexPath.section) {
        case kPNCollectionViewCellSectionOne:
        {
            QYCollectionViewCellSectionOne *tmpCell =(QYCollectionViewCellSectionOne*) [collectionView dequeueReusableCellWithReuseIdentifier:ONE_CELL_IDENTIFIER forIndexPath:indexPath];
            tmpCell.imageView.image = [UIImage imageNamed:self.sectionOneImages[indexPath.row]];
            tmpCell.label.text = self.sectionLabelNames[indexPath.item];
            cell = tmpCell;
            
        }
            break;
        case kPNCollectionViewCellSectionTwo:
        {
            QYCollectionViewCellSectionTwo *twoCell = (QYCollectionViewCellSectionTwo*)[collectionView dequeueReusableCellWithReuseIdentifier:TWO_CELL_IDENTIFIER forIndexPath:indexPath];
            twoCell.imageView.image = [UIImage imageNamed:@"messagescenter_comments_os7"];
            twoCell.titleLabel.text = @"Title";
            twoCell.subTitleLabel.text = @"Subtitle";
            cell = twoCell;
            
        }
            break;
        case kPNCollectionViewCellSectionThree:
        {
            QYCollectionViewCellSectionThree *threeCell = (QYCollectionViewCellSectionThree*)[collectionView dequeueReusableCellWithReuseIdentifier:THREE_CELL_IDENTIFIER forIndexPath:indexPath];
            cell = threeCell;
        }
            break;
        case kPNCollectionViewCellSectionFour:
        {
            QYCollectionViewCellSectionFour *fourCell = (QYCollectionViewCellSectionFour*)[collectionView dequeueReusableCellWithReuseIdentifier:FOUR_CELL_IDENTIFIER forIndexPath:indexPath];
            cell = fourCell;
        }
            break;
        default:
            break;
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section) {
        case kPNCollectionViewCellSectionOne:
            size = CGSizeMake(140, 44);
            break;
        case kPNCollectionViewCellSectionTwo:
            size = CGSizeMake(300, 80);
            break;
        case kPNCollectionViewCellSectionThree:
            size = CGSizeMake(140, 40);
            break;
        case kPNCollectionViewCellSectionFour:
            size = CGSizeMake(57, 70);
            break;
        default:
            break;
    }
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
