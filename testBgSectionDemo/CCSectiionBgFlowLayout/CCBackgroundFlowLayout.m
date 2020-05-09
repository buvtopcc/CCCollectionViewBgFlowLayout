//
//  CCBackgroundFlowLayout.m
//  CCUtil
//
//  Created by pengchangcheng on 2018/10/19.
//  Copyright © 2018 buvtopcc. All rights reserved.
//

#import "CCBackgroundFlowLayout.h"

@implementation CCBackgroundFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 2;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    // 1. get visible sections
    NSMutableSet *displayedSections = [NSMutableSet new];
    NSInteger lastIndex = -1;
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        lastIndex = attr.indexPath.section;
        [displayedSections addObject:@(lastIndex)];
    }
    
    // 2. compute rects for sections that display it, and add attributes for those that intersect
    for (NSNumber * section in displayedSections) {
        BOOL displaysBackground = NO;
        if ([self.collectionView.delegate conformsToProtocol:@protocol(ICCBackgroundFlowLayout)]) {
            id <ICCBackgroundFlowLayout> delegate = (id <ICCBackgroundFlowLayout>)self.collectionView.delegate;
            if ([delegate respondsToSelector:@selector(collectionView:displaysBackgroundAtSection:)]) {
                displaysBackground = [delegate collectionView:self.collectionView displaysBackgroundAtSection:section.unsignedIntegerValue];
            }
        }
        if (displaysBackground) {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForBackgroundAtSection:section.unsignedIntegerValue];
            if (attr) {
                [attributes addObject:attr];
            }
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionViewSupplementaryKindSectionBackground]) {
        return [self layoutAttributesForBackgroundAtSection:indexPath.section];
    } else {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForBackgroundAtSection:(NSUInteger)section
{
    NSUInteger allSections = [self.collectionView numberOfSections];
    NSUInteger numsInSection = [self.collectionView numberOfItemsInSection:section];
    if (section >= allSections || numsInSection <= 0) {
        return nil;
    }
    NSIndexPath *firstIndexPath =[NSIndexPath indexPathForItem:0 inSection:section];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:numsInSection - 1 inSection:section];
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionViewSupplementaryKindSectionBackground withIndexPath:firstIndexPath];
    attr.hidden = NO;
    attr.zIndex = -1; // to send them behind
    
    // 是否有insets
    UIEdgeInsets insets = UIEdgeInsetsZero;
    // 是否需要严格计算
    BOOL shouldStrictlyCal = NO;
    if ([self.collectionView.delegate respondsToSelector:@selector(shouldStrictCalCollectionViewSectionBgFrame:)]) {
        id <ICCBackgroundFlowLayout> delegate = (id <ICCBackgroundFlowLayout>)self.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(shouldStrictCalCollectionViewSectionBgFrame:)]) {
            shouldStrictlyCal = [delegate shouldStrictCalCollectionViewSectionBgFrame:self.collectionView];
        }
        if ([delegate respondsToSelector:@selector(collectionView:backgroundInsetsAtSection:)]) {
            insets = [delegate collectionView:self.collectionView backgroundInsetsAtSection:section];
        }
    }
    
    CGFloat x = insets.left;
    CGFloat y;
    CGFloat w = CGRectGetWidth(self.collectionView.bounds) - insets.left - insets.right;
    CGFloat h;
    
    CGFloat minY = FLT_MAX;
    CGFloat maxY = FLT_MIN;
    
    if (shouldStrictlyCal) { // 遍历所有item得到其中的最大，最小值
        for (NSUInteger i = 0; i < numsInSection; i++) {
            NSIndexPath *cur = [NSIndexPath indexPathForItem:i inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:cur];
            CGFloat curMinY = CGRectGetMinY(attr.frame);
            CGFloat curMaxY = CGRectGetMaxY(attr.frame);
            if (minY > curMinY) {
                minY = curMinY;
            }
            if (maxY < curMaxY) {
                maxY = curMaxY;
            }
        }
    } else { // 只用第一个和最后一个
        UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:firstIndexPath]; // it will be already (section,0)
        UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
        minY = CGRectGetMinY(firstAttr.frame);
        maxY = CGRectGetMaxY(lastAttr.frame);
    }
    y = minY + insets.top;
    h = maxY - minY - insets.bottom - insets.top;
    attr.frame = CGRectMake(x, y, w, h);
    return attr;
}

@end
