//
//  QYEmojiPageView.h
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-16.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYEmojiPageView : UIView

//实现界面的布局， 主要是根据具体的界面需求， 布局表情界面
- (void)loadEmojiItem:(int)page size:(CGSize)size;

//根据系统提供的表情，和表情界面布局的表情数，返回含有表情元素的页面数量
+ (NSUInteger)pagesForAllEmoji:(int)countPerPage;

@end
