//
//  PNCollectionViewCellSectionTwo.m
//  PNWeiBoClient
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 zhangsf. All rights reserved.
//

#import "QYCollectionViewCellSectionTwo.h"

@implementation QYCollectionViewCellSectionTwo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blueColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 47, 47)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 2, 80, 25)];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 20, 150, 44)];
        [self.contentView addSubview:_subTitleLabel];
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
