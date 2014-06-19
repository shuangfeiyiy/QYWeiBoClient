//
//  QYEmojiPageView.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-16.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYEmojiPageView.h"
#import "Emoji.h"

@interface QYEmojiPageView ()
@property (nonatomic, retain) NSArray *allEmojis;
@end

@implementation QYEmojiPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allEmojis = [Emoji allEmoji];
    }
    return self;
}

//一个界面上表情布局是四行九列
- (void)loadEmojiItem:(int)page size:(CGSize)size
{
    //row number
    for (int i=0; i<4; i++) {
        //column numer
        for (int y=0; y<9; y++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            // 每个界面的右下角是一个删除键
            if (i==3 && y==8) {
                [button setImage:[UIImage imageNamed:@"emojiDelete"] forState:UIControlStateNormal];
                button.tag=10000;
                
            }else{
                //这是一个实现的核心点， 就是要设置成表示字体
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [_allEmojis objectAtIndex:i*9+y+(page*35)] forState:UIControlStateNormal];
                button.tag=i*9+y+(page*35);
            }
            [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    
}

- (void)selected:(UIButton*)sender
{
    
}

+ (NSUInteger)pagesForAllEmoji:(int)countPerPage
{
    NSArray *emonjis = [Emoji allEmoji];
    return emonjis.count / countPerPage;
}

@end
