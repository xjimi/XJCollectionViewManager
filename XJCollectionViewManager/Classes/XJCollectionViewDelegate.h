//
//  XJCollectionViewDelegate.h
//  Pods
//
//  Created by XJIMI on 2019/6/10.
//

@protocol XJCollectionViewDelegate <NSObject>
@optional
- (NSInteger)xj_collectionView:(UICollectionView *)collectionView
        numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)xj_collectionView:(UICollectionView *)collectionView
                     cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)xj_collectionView:(UICollectionView *)collectionView
 didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)xj_collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout*)collectionViewLayout
     sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

