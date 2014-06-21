//
//  PNPlazaViewLayout.m
//  PNWeiBoClient
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 zhangsf. All rights reserved.
//

#import "QYPlazaViewLayout.h"

@interface QYPlazaViewLayout ()
@property (nonatomic, assign)NSInteger sectionCount;

@end

@implementation QYPlazaViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    _sectionCount = [self.collectionView numberOfSections];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSInteger i = 0 ; i < self.sectionCount; i++)
    {
        for (NSInteger j = 0; j  < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//            attributes.zIndex = 20;
            
            [allAttributes addObject:attributes];
        }

    }
    return allAttributes;
}

@end
