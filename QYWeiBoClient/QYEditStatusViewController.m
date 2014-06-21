//
//  QYEditStatusViewController.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-9.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYEditStatusViewController.h"
#import "SVProgressHUD.h"
#import "QYFriendViewController.h"
#import "QYEmojiPageView.h"
#import "UIImageView+WebCache.h"
#import "NSString+FrameHeight.h"

//extern CGFloat fontSize;
//#define __USE_IMAGEPICKER_AS_SUBVIEW
@interface QYEditStatusViewController ()<UIActionSheetDelegate,SinaWeiboRequestDelegate,UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) UIToolbar *kbTopBarView;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSMutableArray *postImages;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipGesture;
@property (nonatomic, retain) UIScrollView *emojiScrollView;
@end

@implementation QYEditStatusViewController
{
    UIView *retweetBgView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSLog(@"%f",fontSize);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    
    self.kbTopBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 568, 320, 44)];
//    当kbTopBarView的父视图发生变化的时候，kbTopBarView高度自动变化，顶部对齐
    self.kbTopBarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [self createKeyBoardTopBarItems];
    [self.view addSubview:self.kbTopBarView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [QYNSDC addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [QYNSDC addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    当用户输入多个空格的时候， 是否允许发送
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"分享新鲜事..."]) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [self showEditStatusView];
    
}


- (void)showEditStatusView
{
    if (self.mDicStatus != nil) {
        self.textView.text = [self.mDicStatus objectForKey:@"text"];
        
        CGFloat textViewHeight = [self.textView.text frameHeightWithFontSize:14.0f forViewWidth:300.0f];
        retweetBgView = [[UIView alloc] initWithFrame:CGRectMake(0, textViewHeight+10, 300, 80)];
        retweetBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        retweetBgView.layer.borderWidth = 0.5f;
        UIImageView *thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [retweetBgView addSubview:thumbImageView];
        [thumbImageView release];
        
        UILabel *retweetUserName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thumbImageView.frame)+10, 10, 200, 20)];
        [retweetBgView addSubview:retweetUserName];
        
        UILabel *retweetStatusText = [[UILabel alloc] initWithFrame:CGRectMake(retweetUserName.frame.origin.x, CGRectGetMaxY(retweetUserName.frame)+5, 200, 40)];
        retweetStatusText.numberOfLines = 2;
        retweetStatusText.textColor = [UIColor lightGrayColor];
        retweetStatusText.font = [UIFont systemFontOfSize:13.0f];
        [retweetBgView addSubview:retweetStatusText];
        
        NSDictionary *dicRetweetStatus = [self.mDicStatus objectForKey:kStatusRetweetStatus];
        //      如果被转发的微博包含转发微博，那么当前转发内容需要附带被转发微博的转发微博
        if (dicRetweetStatus != nil) {
            //            如果被转发的微博转发的内容有图片，则提取出此图片，如果没有图片，则使用被转发用户的头像作为图片。
            NSArray *arrayPicUrls = [dicRetweetStatus objectForKey:kStatusPicUrls];
            if (arrayPicUrls != nil && arrayPicUrls.count > 0) {
                NSURL *imgUrl =[NSURL URLWithString:[[arrayPicUrls objectAtIndex:0] objectForKey:kStatusThumbnailPic]];
                UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgUrl]];
                thumbImageView.image = img;
            }else
            {
                [thumbImageView setImageWithURL:[NSURL URLWithString:[[dicRetweetStatus objectForKey:kStatusUserInfo] objectForKey:kUserAvatarLarge]]];
            }
            retweetUserName.text = [[dicRetweetStatus objectForKey:kStatusUserInfo] objectForKey:kUserInfoScreenName];
            retweetStatusText.text = [dicRetweetStatus objectForKey:kStatusText];
            
        }else{
            //如果没有转发微博，则使用被转发的微博博主的头像作为图片。
            if (thumbImageView.image == nil) {
                [thumbImageView setImageWithURL:[NSURL URLWithString:[[self.mDicStatus objectForKey:kStatusUserInfo] objectForKey:kUserAvatarLarge]]];
            }
            retweetUserName.text = [[self.mDicStatus objectForKey:kStatusUserInfo] objectForKey:kUserInfoScreenName];
            retweetStatusText.text = [self.mDicStatus objectForKey:kStatusText];
            
        }
        [self.textView addSubview:retweetBgView];
        
        [retweetUserName release];
        [retweetStatusText release];
    }

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [QYNSDC removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [QYNSDC removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)createKeyBoardTopBarItems
{
    //创建UIToolBar上的Items
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //照相机
    UIBarButtonItem *cameraItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(onCameraBarItemTapped:)];
    //图片库
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(onPhotoBarItemTapped:)];
    //联系人列表
    UIBarButtonItem *atContactItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAtContactItemTapped:)];
    //表情库
    UIBarButtonItem *emotionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onEmotionItemTapped:)];
    //更多
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddItemTapped:)];
    
    [self.kbTopBarView setItems:@[cameraItem,flexItem,photoItem,flexItem,atContactItem,flexItem,emotionItem,flexItem,addItem]];
}

#pragma mark -
#pragma mark KeyBoard top toolbar item callback method
- (void)onEmotionItemTapped:(UIBarButtonItem*)sender
{
    if (self.emojiScrollView != nil) {
        [self.emojiScrollView removeFromSuperview];
        self.emojiScrollView = nil;
        [self.textView becomeFirstResponder];
    }else
    {
        self.emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 216, 320, 216)];
        self.emojiScrollView.backgroundColor = [UIColor orangeColor];
        int nPageCount = [QYEmojiPageView pagesForAllEmoji:35];
        self.emojiScrollView.contentSize = CGSizeMake(320*nPageCount, 216);
        self.emojiScrollView.pagingEnabled = YES;
        
        for (int i = 0; i < nPageCount; i++) {
            QYEmojiPageView *fview=[[QYEmojiPageView alloc] initWithFrame:CGRectMake(10+320*i, 15, 300, 170)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadEmojiItem:i size:CGSizeMake(33, 43)];
            [self.emojiScrollView addSubview:fview];
            
        }

        [self.view addSubview:self.emojiScrollView];
//        [self.textView.textInputView addSubview:self.emojiScrollView];
        [self.textView resignFirstResponder];

    }
}
- (void)onAtContactItemTapped:(UIBarButtonItem*)sender
{
    QYFriendViewController *friendViewController = [[QYFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self presentViewController:friendViewController animated:YES completion:nil];
    QYSafeRelease(friendViewController);
}

- (void)onCameraBarItemTapped:(UIBarButtonItem*)sender
{
    [self.textView resignFirstResponder];
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void)onPhotoBarItemTapped:(UIBarButtonItem*)sender
{
    [self.textView resignFirstResponder];
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)onAddItemTapped:(UIBarButtonItem*)sender
{
    
}

#pragma mark -
#pragma mark Camera picker
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    //  用于判断当前设备是否支持相机或者图片库
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = sourceType;
#ifdef __USE_IMAGEPICKER_AS_SUBVIEW
        picker.view.frame = CGRectMake(0, 0, picker.view.frame.size.width, picker.view.frame.size.height);
        [picker viewDidAppear:YES];
        [picker viewWillAppear:YES];
        self.navigationController.navigationBarHidden = YES;
        [self.view addSubview:picker.view];
#else
        //      展示模态控制器，在此处必须使用这种方式，不能使用导航控制器
        [self presentViewController:picker animated:YES completion:nil];
        
#endif
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media" message:@"Device doesn't support that media source." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    CGSize size = [self.textView.text sizeWithAttributes:attributes];
    CGFloat textViewHeight =ceilf(size.width / size.height + 20.0f);
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageView *wbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, textViewHeight+20, 80, 100)];
    wbImageView.image = chosenImage;
    [self.textView addSubview:wbImageView];
    [wbImageView release];
    if (self.postImages == nil) {
        self.postImages = [[NSMutableArray alloc] init];
    }
    [self.postImages addObject:chosenImage];
#ifdef __USE_IMAGEPICKER_AS_SUBVIEW
    [picker.view removeFromSuperview];
    [picker release];
    self.navigationController.navigationBarHidden = NO;
#else
    [picker dismissViewControllerAnimated:YES completion:nil];
#endif
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
#ifdef __USE_IMAGEPICKER_AS_SUBVIEW
    [picker.view removeFromSuperview];
    [picker release];
    self.navigationController.navigationBarHidden = NO;
#else
    [picker dismissViewControllerAnimated:YES completion:nil];
#endif
}


- (IBAction)onCancelButton:(UIButton *)sender
{
    if (self.textView.text.length != 0) {
        UIActionSheet *tipUser = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存草稿", nil];
        [tipUser showInView:[UIApplication sharedApplication].keyWindow];
    }else
    {
        if (self.navigationController != nil)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

//普通用户只能发送单张图片， 如果需要发送多张图片，则需要申请
- (IBAction)onSendButton:(UIButton *)sender
{
    
    [SVProgressHUD showWithStatus:@"正在发送..."];
//    用于判断当前编辑的微博是否附带有微博图片，如果没有，则调用statuses/update.json。
    if (nil == self.postImages || self.postImages.count == 0) {
        [appDelegate.sinaWeibo requestWithURL:@"statuses/update.json"
                                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.textView.text, @"status", nil]
                                   httpMethod:@"POST"
                                     delegate:self];
    }else
    {
        UIImage *postImage = [self.postImages lastObject];
        [appDelegate.sinaWeibo requestWithURL:@"statuses/upload.json"
                                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               self.textView.text, @"status",
                                               postImage, @"pic", nil]
                                   httpMethod:@"POST"
                                     delegate:self];
    }

}

#pragma mark -
#pragma mark UIKeyboard notification
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    //键盘弹出的时候， 在view上添加一个手势，当点击除键盘之外的任何区域，让键盘消失
    self.swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onUserTappedViewWithKeybboarShow:)];
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.textView addGestureRecognizer:self.swipGesture];

    NSDictionary *userInfo = nofication.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect kbTopBarViewShowFrame = (CGRect){keyboardFrame.origin.x,keyboardFrame.origin.y-44,320,44};
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.kbTopBarView.frame = kbTopBarViewShowFrame;
                     }
                     completion:nil];
}

- (void)onUserTappedViewWithKeybboarShow:(UISwipeGestureRecognizer*)gesture
{
    [self.textView resignFirstResponder];
}

- (void)keyBoardWillHide:(NSNotification*)nofication
{
    [self.textView removeGestureRecognizer:self.swipGesture];
    
//  如果当前显示的是表情视图，则键盘上方的工具条不做调整
    if (self.emojiScrollView != nil) {
        NSDictionary *userInfo = nofication.userInfo;
        CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        [UIView animateWithDuration:timerInterval
                              delay: 0.0
                            options: animationOptions
                         animations:^{
                             self.kbTopBarView.frame = CGRectMake(0, CGRectGetMinY(keyboardFrame)-44,320,44);
                         }
                         completion:nil];
        return;
    }
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.kbTopBarView.frame = CGRectMake(0, CGRectGetMinY(keyboardFrame)-44,320,44);
                     }
                     completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length > 0 && ![self.textView.text isEqualToString:@"分享新鲜事..."]) {
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
//实现textView的PlaceHolder功能
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"分享新鲜事..."]) {
        textView.text = @"";
    }else if (textView.text.length == 0)
    {
        textView.text = @"分享新鲜事...";
        textView.selectedRange = range;
    }
    return YES;
}
//当TextView开始编辑的时候，将光标移动到行首
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    NSRange range;
    range.location = 0;
    range.length = 0;
    textView.selectedRange =range;
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *statusText = self.textView.text;
    NSDictionary *dicStatus = nil;
    if (self.postImages.count > 0) {
        UIImage *statusImage = [self.postImages lastObject];
        dicStatus = @{kStatusText:statusText,@"image":statusImage};
    }else
    {
        dicStatus = @{kStatusText:statusText};
    }
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
         [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_cancelButton release];
    [_sendButton release];
    [_textView release];
    [super dealloc];
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
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
