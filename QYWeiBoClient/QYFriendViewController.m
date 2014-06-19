//
//  QYFriendViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-13.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYFriendViewController.h"
#import "UIImageView+WebCache.h"
#import "ChineseToPinyin.h"
#import "QYCustomView.h"

@interface QYFriendViewController ()<SinaWeiboRequestDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,retain) NSArray *friendList;
@property (nonatomic,retain) NSArray *indexKeys;
@property (nonatomic,retain) NSMutableDictionary *showContacts;
@property (nonatomic,retain) NSArray *sectionTitle;
//为了便于操作数据而又不破坏原始数据，这个数组存放的数据是原始数据的一份复制
@property (nonatomic, retain) NSArray *modifyFriendContacts;
@end

@implementation QYFriendViewController
{
    UIView *titleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//   从新浪服务器获取数据
    [self requestFriendContactsFromServer];
    self.indexKeys = [[NSArray alloc]initWithObjects:UITableViewIndexSearch,
                      @"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                      @"J",@"K", @"L", @"M",@"N", @"O", @"P", @"Q", @"R",
                      @"S", @"T", @"U", @"V", @"W", @"X",  @"Y", @"Z", @"#",nil];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = @"输入联系人名字";
    self.searchBar.showsBookmarkButton = YES;
    
    
   
//    self.searchBar.showsCancelButton = YES;
//    self.searchBar.barStyle = UIBarStyleBlack;
//    self.searchBar.barTintColor = [UIColor orangeColor];
//
//    self.tableView.contentOffset = CGPointMake(0, -44);
//    self.tableView.contentInset =  UIEdgeInsetsMake(44, 0, 0, 0);
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
//    bgView.userInteractionEnabled = YES;
//    self.tableView.backgroundView = bgView;
//    
//    titleView = [[QYCustomView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    titleView.userInteractionEnabled = YES;
//    titleView.backgroundColor = [UIColor orangeColor];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 4.5, 80, 35)];
//    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(onCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//    [titleView addSubview:button];
//    [self.tableView.backgroundView addSubview:titleView];
    
}

- (void)onCancelButton:(UIButton*)sender
{
    [titleView removeFromSuperview];
     [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//对于UITableViewController的TableView需要在viewDidAppear方法修改frame
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect newFrame = {0,20,320,480};
    [ self.tableView setFrame:newFrame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.showContacts.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.sectionTitle[section] ;
    NSArray *friends = self.showContacts[key];
    return friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndectifier = @"FriendCelll";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndectifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndectifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.tag = 1000;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, 200, 40)];
        labelText.tag = 1001;
        [cell.contentView addSubview:labelText];
        [labelText release];
    }
    NSString *key = self.sectionTitle[indexPath.section];
    NSArray *friends = self.showContacts[key];
    NSDictionary *cellData = friends[indexPath.row];

    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1000];
    [imageView setImageWithURL:[NSURL URLWithString:[cellData objectForKey:@"avatar_hd"]]];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:1001];
    label.text = [cellData objectForKey:@"screen_name"];
    return cell;
}


- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self.searchBar showsCancelButton]) {
        return nil;
    }

    return self.indexKeys;

}


//当点击右边的索引时回调此方法，参数titile是索引值，比如：A , B ,C ...
- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) {
//        如果点击的是放大镜图标， 则将tableView的可视界面以动画的形式滚动到搜索栏
        [self.tableView scrollRectToVisible:self.searchBar.frame animated:YES];
        return -1;
    }
    
    NSInteger i = [self.sectionTitle indexOfObject:title];
    return i;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitle[section];
}


////如果tableView重写以下关于section的方法，并返回了具体的视图值，那么titleForHeaderInSection这个方法将不会被调用。
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc ] initWithFrame:CGRectMake(100, 0, 200, 32)];
//    label.backgroundColor = [UIColor redColor];
////    label.text = @"Hello";
//    label.alpha = 0;
//    return label;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)requestFriendContactsFromServer
{
    
    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
}

#pragma mark -
#pragma mark SinaWeiboRequestDelegate

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
    self.friendList = [result objectForKey:@"users"];
    self.modifyFriendContacts = [self.friendList copy];
    [self createShowDataStruct];
    [self.tableView reloadData];
}

- (NSString *) getPinYinNameFirstLetter:(NSString*)username
{
	if ([username canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
		return [[NSString stringWithFormat:@"%c",[username characterAtIndex:0]] uppercaseString];
	}
	else {
        //如果是汉子的名字，则取汉子的拼音首字母
		return [[NSString stringWithFormat:@"%c",pinyinFirstLetter([username characterAtIndex:0])] uppercaseString];
	}
}

- (void)createShowDataStruct
{
    NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dicContact in self.modifyFriendContacts)
    {
        NSString *friendName = [dicContact objectForKey:@"screen_name"];
        NSString *nameFirstLetter = [self getPinYinNameFirstLetter:friendName];
        
//        判断nameFirstLeter是不是一个英文字符
        if (!isalpha([nameFirstLetter characterAtIndex:0])) {
            nameFirstLetter = @"#";
        }
        
        NSMutableArray  *tempContactArray = [contactDictionary objectForKey:nameFirstLetter];
        if (nil == tempContactArray) {
            tempContactArray = [[NSMutableArray alloc] init];
            [tempContactArray addObject:dicContact];
            [contactDictionary setObject:tempContactArray forKey:nameFirstLetter];
            [tempContactArray release];
        }
        else{
            [tempContactArray addObject:dicContact];
        }
    }
    self.showContacts = contactDictionary;
    
//    将字典所有的key按字母进行排序（不区大小写）
    NSMutableArray *titlesArry = [[[contactDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy];
    
//    将#号放到数组的末尾位置
    NSInteger indexOfJing = [titlesArry indexOfObject:@"#"];
    if(indexOfJing != NSNotFound){
        [titlesArry removeObjectAtIndex:indexOfJing];
        [titlesArry addObject:@"#"];
    }
    self.sectionTitle = titlesArry;
    [titlesArry release];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UISearchBar Delegate

//当点击搜索栏键盘上右下角的搜索键的时候，此委托方法被调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self doSearchWith:searchBar.text];
}

//当第一次点击搜索栏开始输入搜索内容的时候 这个委托方法被调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

//当搜索展示书签按纽的时候， 当点击这个按纽时， 此委托方法被调用
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Bookmark Button clicked");
}

//当搜索栏展示取消按纽的时候， 当点击这个按纽的时候，此委托方法被调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)doSearchWith:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"screen_name CONTAINS[c] %@",searchText];
    self.modifyFriendContacts = [self.friendList filteredArrayUsingPredicate:predicate];
    [self createShowDataStruct];
    [self.tableView reloadData];
    
    if ([searchText isEqualToString:@""]) {
        //输入框内容为空时，恢复数据
        self.modifyFriendContacts = [self.friendList copy];
        [self createShowDataStruct];
        [self.tableView reloadData];
    }
    else{
        //输入框不空时，即时搜索
        [self searchWithUserName:searchText];
    }
}

//实现实时搜索功能
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self doSearchWith:searchText];

}

- (void)searchWithUserName:(NSString*)userName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"screen_name CONTAINS[c] %@",userName];
    self.modifyFriendContacts = [self.friendList filteredArrayUsingPredicate:predicate];
    [self createShowDataStruct];
    [self.tableView reloadData];
}
- (void)dealloc {
    [_searchBar release];
    [super dealloc];
}
@end
