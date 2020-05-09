//
//  ViewController.m
//  testBgSectionDemo
//
//  Created by buvtopcc on 2020/5/9.
//  Copyright © 2020 buvtopcc. All rights reserved.
//

#import "ViewController.h"
#import "CCBackgroundFlowLayout.h"

static NSUInteger kTagTextLabel = 999;
static NSUInteger kSectionCount = 10;
static NSString *const kCellIdentifier = @"CellID";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ICCBackgroundFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CCBackgroundFlowLayout *layout = [[CCBackgroundFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    cv.delegate = self;
    cv.dataSource = self;
    [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [CCSectionBackgroundView registeSupplementaryViewFor:cv];
    [self.view addSubview:cv];
}

#pragma mark - DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kSectionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                           forIndexPath:indexPath];
    UILabel *lb = [cell viewWithTag:kTagTextLabel];
    if (!lb) {
        lb = [[UILabel alloc] initWithFrame:cell.bounds];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor blackColor];
        lb.tag = kTagTextLabel;
        lb.layer.borderColor = [UIColor orangeColor].CGColor;
        lb.layer.borderWidth = 1;
        [cell.contentView addSubview:lb];
    }
    lb.text = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionViewSupplementaryKindSectionBackground]) {
        CCSectionBackgroundView *backView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                          withReuseIdentifier:KCCSectionBackgroundViewIndentifier
                                                  forIndexPath:indexPath];
        NSArray *colorArray = @[UIColor.redColor, UIColor.blueColor, UIColor.greenColor];
        backView.backgroundColor = colorArray[rand() % 3];
        return backView;
    }
    return nil;
}

#pragma mark - FlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (section == kSectionCount - 1) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
}

#pragma mark - Background
- (BOOL)collectionView:(UICollectionView *)collectionView displaysBackgroundAtSection:(NSUInteger)section
{
    return YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView backgroundInsetsAtSection:(NSUInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10); // UIEdgeInsetsZero
}

- (BOOL)shouldStrictCalCollectionViewSectionBgFrame:(UICollectionView *)collectionView
{
    return YES;
}

@end
