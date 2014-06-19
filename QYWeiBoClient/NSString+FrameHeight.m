//
//  NSString+FrameHeight.m
//  QYWeiBoClient
//
//  Created by QingYun on 14-6-17.
//  Copyright (c) 2014年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSString+FrameHeight.h"

@implementation NSString (FrameHeight)
//下面的算法， 由于考虑到计算每行显示的字数时， 使用了向下取整的算法， 所以不能将整个算法
//精简为字符串的宽度/视图的宽度
- (CGFloat)frameHeightWithFontSize:(CGFloat)fontSize forViewWidth:(CGFloat)width
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [self sizeWithAttributes:attributes];
    //每一行可以显示的字数， 使用控件的宽度/单个字体的宽度，向下取整
    NSUInteger wordsPerLine = floor(width /fontSize);
//    每一行显示所使用的宽度（单个字体的宽度＊每一行显示的字数）
    CGFloat widthPerLine = fontSize * wordsPerLine;
//    显示的行数，使用字符串的整体宽度/每一行的宽度
    NSUInteger nLines = ceil(size.width / widthPerLine);
//    根据字体的高度，获取字符串所占用的行高
    CGFloat height = nLines * (size.height);
    return height;
}
@end
