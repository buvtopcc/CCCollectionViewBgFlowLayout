//
//  CCBackgroundFlowLayout.h
//  CCUtil
//
//  Created by pengchangcheng on 2018/10/19.
//  Copyright © 2018 buvtopcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSectionBackgroundView.h"

@protocol ICCBackgroundFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
// default is no
- (BOOL)collectionView:(UICollectionView *)collectionView displaysBackgroundAtSection:(NSUInteger)section;
// default is UIEdgeInsetsZero
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView backgroundInsetsAtSection:(NSUInteger)section;
// default is no
- (BOOL)shouldStrictCalCollectionViewSectionBgFrame:(UICollectionView *)collectionView;

@end

@interface CCBackgroundFlowLayout : UICollectionViewFlowLayout

@end


