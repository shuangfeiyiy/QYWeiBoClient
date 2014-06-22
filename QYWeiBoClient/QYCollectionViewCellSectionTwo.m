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
        self.contentView.backgroundColor = [UIColor whiteColor];
        CGFloat fontSize = 14.0f;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 17, 80, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 42, 150, 20)];
        _subTitleLabel.font = [UIFont systemFontOfSize:fontSize];
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
