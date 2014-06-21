//
//  PNCollectionViewCellSectionOne.m
//  PNWeiBoClient
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 zhangsf. All rights reserved.
//

#import "QYCollectionViewCellSectionOne.h"

@implementation QYCollectionViewCellSectionOne

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"square_card_bg"]];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10 , 30, 30)];
        [self.contentView addSubview:_imageView];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 60, 30)];
        _label.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_label];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
