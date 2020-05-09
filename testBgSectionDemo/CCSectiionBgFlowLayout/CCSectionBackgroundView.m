//
//  CCSectionBackgroundView.m
//  CCUtil
//
//  Created by pengchangcheng on 2018/10/19.
//  Copyright © 2018 buvtopcc. All rights reserved.
//

#import "CCSectionBackgroundView.h"

NSString * const UICollectionViewSupplementaryKindSectionBackground = @"UICVSupplementaryKindSectionBackground";
NSString * const KCCSectionBackgroundViewIndentifier = @"CCSectionBackgroundView";

@implementation CCSectionBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (void)registeSupplementaryViewFor:(UICollectionView *)collectionView
{
    [collectionView registerClass:[self class]
       forSupplementaryViewOfKind:UICollectionViewSupplementaryKindSectionBackground
              withReuseIdentifier:KCCSectionBackgroundViewIndentifier];
}

@end
