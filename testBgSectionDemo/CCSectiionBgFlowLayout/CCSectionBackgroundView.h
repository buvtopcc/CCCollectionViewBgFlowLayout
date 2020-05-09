//
//  CCSectionBackgroundView.h
//  CCUtil
//
//  Created by pengchangcheng on 2018/10/19.
//  Copyright © 2018 buvtopcc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UICollectionViewSupplementaryKindSectionBackground;
extern NSString * const KCCSectionBackgroundViewIndentifier;

@interface CCSectionBackgroundView : UICollectionReusableView

+ (void)registeSupplementaryViewFor:(UICollectionView *)collectionView;

@end
