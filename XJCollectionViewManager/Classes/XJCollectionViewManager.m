//
//  XJCollectionViewManager.m
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewManager.h"

@interface XJCollectionViewManager () < UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout >

@property (nonatomic, strong) NSMutableArray *registeredCells;
@property (nonatomic, copy)   XJCollectionViewForSupplementaryElementBlock viewForSupplementaryElementBlock;
@property (nonatomic, copy)   XJCollectionViewCellForItemBlock cellForItemBlock;
@property (nonatomic, copy)   XJCollectionViewWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic, copy)   XJCollectionViewDidSelectItemBlock didSelectItemBlock;

@end

@implementation XJCollectionViewManager

+ (nonnull instancetype)managerWithCollectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.data = [NSMutableArray array];
        self.registeredCells = [NSMutableArray array];
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)addViewForSupplementaryElementBlock:(nonnull XJCollectionViewForSupplementaryElementBlock)supplementaryElementBlock {
    self.viewForSupplementaryElementBlock = supplementaryElementBlock;
}

- (void)addCellForItemBlock:(nonnull XJCollectionViewCellForItemBlock)itemBlock {
    self.cellForItemBlock = itemBlock;
}

- (void)addWillDisplayCellBlock:(nonnull XJCollectionViewWillDisplayCellBlock)cellBlock {
    self.willDisplayCellBlock = cellBlock;
}

- (void)addDidSelectItemBlock:(nonnull XJCollectionViewDidSelectItemBlock)itemBlock {
    self.didSelectItemBlock = itemBlock;
}

- (void)reloadData
{
    [UIView performWithoutAnimation:^{
        [super reloadData];
    }];
}

- (void)setData:(nullable NSMutableArray *)data
{
    if (!data) data = [NSMutableArray array];
    [self registerCellWithData:data];
    _data = [data mutableCopy];
    [self reloadData];
}

- (void)appendRowsWithDataModel:(nonnull XJCollectionViewDataModel *)dataModel
{
    if (!dataModel.section && !dataModel.rows.count) return;
    
    if (!_data)
    {
        self.data = @[dataModel].mutableCopy;
        return;
    }
    
    [self registerCellWithData:@[dataModel]];
    
    NSInteger sessionIndex = self.data.count - 1;
    for (XJCollectionViewDataModel *data in self.data)
    {
        if ([dataModel.section.sectionId isEqualToString:data.section.sectionId]) {
            sessionIndex = [self.data indexOfObject:data];
            break;
        }
    }

    XJCollectionViewDataModel *curDataModel = [self.data objectAtIndex:sessionIndex];
    NSInteger numberOfRows = curDataModel.rows.count;
    NSInteger totalRowsCount = curDataModel.rows.count + dataModel.rows.count;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = numberOfRows; i < totalRowsCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sessionIndex]];
    }
    [curDataModel.rows addObjectsFromArray:dataModel.rows];
    
    [UIView performWithoutAnimation:^{
        [self insertItemsAtIndexPaths:indexPaths];
    }];
}

- (void)appendDataModel:(nonnull XJCollectionViewDataModel *)dataModel {
    [self insertDataModel:dataModel atSectionIndex:self.data.count];
}

- (void)insertDataModel:(nonnull XJCollectionViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex
{
    if (!dataModel.section && !dataModel.rows.count) return;
    
    if (!self.data) {
        self.data = @[dataModel].mutableCopy;
        return;
    }
    
    [self registerCellWithData:@[dataModel]];

    if (sectionIndex > self.data.count) {
        sectionIndex = self.data.count;
    }
    
    [self.data insertObject:dataModel atIndex:sectionIndex];

    [UIView performWithoutAnimation:^{
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    }];
}

- (void)registerCellWithData:(nonnull NSArray *)data
{
    for (XJCollectionViewDataModel *dataModel in data)
    {
        if (dataModel.section)
        {
            NSString *reusableId = dataModel.section.identifier;
            
            if (![self.registeredCells containsObject:reusableId])
            {
                [self.registeredCells addObject:reusableId];
                NSString *kind = UICollectionElementKindSectionHeader;
                if([[NSBundle mainBundle] pathForResource:reusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:reusableId bundle:nil];
                    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:reusableId];
                }
                else
                {
                    Class class = NSClassFromString(reusableId);
                    [self registerClass:class forSupplementaryViewOfKind:kind withReuseIdentifier:reusableId];
                }
            }
        }
        
        if (dataModel.rows)
        {
            for (XJCollectionViewCellModel *cellModel in dataModel.rows)
            {
                NSString *cellId = cellModel.identifier;
                if ([self.registeredCells containsObject:cellId]) continue;
                [self.registeredCells addObject:cellId];
                if([[NSBundle mainBundle] pathForResource:cellId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:cellId bundle:nil];
                    [self registerNib:nib forCellWithReuseIdentifier:cellId];
                }
                else
                {
                    Class class = NSClassFromString(cellId);
                    [self registerClass:class forCellWithReuseIdentifier:cellId];
                }
            }
        }
    }
}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    XJCollectionViewDataModel *dataModel = self.data[section];
    if (dataModel.section) {
        return dataModel.section.size;
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    if (dataModel.section.identifier)
    {
        if([kind isEqual:UICollectionElementKindSectionHeader])
        {
            XJCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dataModel.section.identifier forIndexPath:indexPath];
            if ([headerView respondsToSelector:@selector(reloadData:)])  [headerView reloadData:dataModel.section.data];
            if (self.viewForSupplementaryElementBlock) {
                self.viewForSupplementaryElementBlock (kind, dataModel.section, headerView, indexPath);
            }
            
            return headerView;
        }
        else if ([kind isEqual:UICollectionElementKindSectionFooter])
        {
            XJCollectionViewHeader *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dataModel.section.identifier forIndexPath:indexPath];
            if ([footerView respondsToSelector:@selector(reloadData:)]) [footerView reloadData:dataModel.section.data];
            if (self.viewForSupplementaryElementBlock) {
                self.viewForSupplementaryElementBlock (kind, dataModel.section, footerView, indexPath);
            }

            return footerView;
        }
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    XJCollectionViewDataModel *dataModel = self.data[section];
    if (![self.collectionViewDelegate respondsToSelector:@selector(xj_collectionView:numberOfItemsInSection:)]) {
        return dataModel.rows.count;
    } else {
        return [self.collectionViewDelegate xj_collectionView:collectionView numberOfItemsInSection:section];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(xj_collectionView:layout:sizeForItemAtIndexPath:)]) {
        CGSize size = [self.collectionViewDelegate xj_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
        if (!CGSizeEqualToSize(CGSizeZero, size)) {
            return size;
        }
    }

    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(xj_collectionView:cellForItemAtIndexPath:)]) {
        UICollectionViewCell *cell = [self.collectionViewDelegate xj_collectionView:collectionView cellForItemAtIndexPath:indexPath];
        if (cell) return cell;
    }

    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    XJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellModel.identifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
    if ([cell respondsToSelector:@selector(reloadData:)]) [cell reloadData:cellModel.data];
    if (self.cellForItemBlock) self.cellForItemBlock(cellModel, cell, indexPath);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    if (indexPath.row >= dataModel.rows.count) return;
    XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    if (self.willDisplayCellBlock) self.willDisplayCellBlock(cellModel, (XJCollectionViewCell *)cell, indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(xj_collectionView:didSelectItemAtIndexPath:)]) {
        [self.collectionViewDelegate xj_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        return;
    }

    if (self.didSelectItemBlock)
    {
        XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
        XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
        self.didSelectItemBlock(cellModel, indexPath);
    }
}

#pragma mark

- (nullable XJCollectionViewCellModel *)cellModelAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section >= self.data.count) {
        return nil;
    }
    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    if (indexPath.row >= dataModel.rows.count) {
        return nil;
    }
    XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel;
}

- (nullable XJCollectionReusableModel *)headerModelAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section >= self.data.count) {
        return nil;
    }
    XJCollectionViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    return dataModel.section;
}

- (nullable NSString *)sessionIdAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XJCollectionReusableModel *headerModel = [self headerModelAtIndexPath:indexPath];
    return headerModel.sectionId;
}


@end
