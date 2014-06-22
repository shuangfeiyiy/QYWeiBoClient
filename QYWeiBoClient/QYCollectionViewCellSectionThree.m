//
//  PNCollectionViewCellThree.m
//  PNWeiBoClient
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 zhangsf. All rights reserved.
//

#import "QYCollectionViewCellSectionThree.h"

@interface QYCollectionViewCellSectionThree ()
@end


@implementation QYCollectionViewCellSectionThree

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _labelTrend = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelTrend.textAlignment = NSTextAlignmentCenter;
        _labelTrend.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_labelTrend];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectMake(0, 0, 140, 40);
    self.labelTrend.frame = frame;
    self.labelTrend.text = [NSString stringWithFormat:@"#%@#",self.mDicTrends[@"name"]];
}
@end
