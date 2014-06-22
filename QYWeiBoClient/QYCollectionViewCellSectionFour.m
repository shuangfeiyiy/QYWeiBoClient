//
//  PNCollectionViewCellSectionFour.m
//  PNWeiBoClient
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 zhangsf. All rights reserved.
//

#import "QYCollectionViewCellSectionFour.h"

@interface QYCollectionViewCellSectionFour ()
@property (nonatomic, retain) UILabel *labelTrend;
@end
@implementation QYCollectionViewCellSectionFour

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _labelTrend = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_labelTrend];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectMake(10, 10, 57, 70);
    self.labelTrend.frame = frame;
}
@end
