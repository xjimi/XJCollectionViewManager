//
//  XJCollectionViewManager.m
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewManager.h"

@interface XJCollectionViewManager () < UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout >

@property (nonatomic, strong) NSMutableArray <XJCollectionViewDataModel *> *dataModels;
@property (nonatomic, strong) NSMutableDictionary *registeredCells;
@property (nonatomic, copy)   XJCollectionViewCellForItemBlock cellForItemBlock;
@property (nonatomic, copy)   XJCollectionViewWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic, copy)   XJCollectionViewDidSelectItemBlock didSelectItemBlock;
@property (nonatomic, copy)   XJCollectionViewForSupplementaryElementBlock viewForSupplementaryElementBlock;

@end

@implementation XJCollectionViewManager

+ (instancetype)managerWithCollectionViewLayout:(UICollectionViewLayout *)layout {
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
        self.dataModels = [NSMutableArray array];
        self.registeredCells = [NSMutableDictionary dictionary];
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)reloadData
{
    [UIView performWithoutAnimation:^{
        [super reloadData];
    }];
}

#pragma mark - Collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataModels.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    return dataModel.header ? dataModel.header.size : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    return dataModel.footer ? dataModel.footer.size : CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        XJCollectionViewHeaderModel *header = [self headerModelAtIndexPath:indexPath];
        if (!header.identifier.length) return nil;

        XJCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header.identifier forIndexPath:indexPath];
        if ([headerView respondsToSelector:@selector(reloadData:)])  [headerView reloadData:header.data];
        if (self.viewForSupplementaryElementBlock) {
            self.viewForSupplementaryElementBlock (kind, header, headerView, indexPath);
        }

        return headerView;
    }
    else if ([kind isEqual:UICollectionElementKindSectionFooter])
    {
        XJCollectionViewFooterModel *footer = [self footerModelAtIndexPath:indexPath];
        if (!footer.identifier.length) return nil;

        XJCollectionViewHeader *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer.identifier forIndexPath:indexPath];
        if ([footerView respondsToSelector:@selector(reloadData:)]) [footerView reloadData:footer.data];
        if (self.viewForSupplementaryElementBlock) {
            self.viewForSupplementaryElementBlock (kind, footer, footerView, indexPath);
        }

        return footerView;
    }

    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
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

    XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(xj_collectionView:cellForItemAtIndexPath:)]) {
        UICollectionViewCell *cell = [self.collectionViewDelegate xj_collectionView:collectionView cellForItemAtIndexPath:indexPath];
        if (cell) return cell;
    }

    XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
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
    XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
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
        XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        self.didSelectItemBlock(cellModel, indexPath);
    }
}

#pragma mark - Refresh dataModel

- (void)setDataModels:(NSMutableArray<XJCollectionViewDataModel *> *)dataModels
{
    [self registerCellWithData:dataModels];
    _dataModels = [dataModels mutableCopy];
    [self reloadData];
}

- (void)refreshDataModel:(XJCollectionViewDataModel *)dataModel
{
    if (!dataModel) return;
    [self refreshDataModels:@[dataModel]];
}

- (void)refreshDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels
{
    if (!dataModels || !dataModels.count) return;
    self.dataModels = dataModels.mutableCopy;
}

#pragma mark - Append dataModel

- (void)appendRowsWithDataModel:(XJCollectionViewDataModel *)dataModel
{
    if (!dataModel.header && !dataModel.rows.count) return;
    
    if (!_dataModels)
    {
        self.dataModels = @[dataModel].mutableCopy;
        return;
    }
    
    [self registerCellWithData:@[dataModel]];
    
    NSInteger sessionIndex = self.dataModels.count - 1;
    for (XJCollectionViewDataModel *data in self.dataModels)
    {
        if ([dataModel.header.sectionId isEqualToString:data.header.sectionId]) {
            sessionIndex = [self.dataModels indexOfObject:data];
            break;
        }
    }

    XJCollectionViewDataModel *curDataModel = [self.dataModels objectAtIndex:sessionIndex];
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

- (void)appendDataModel:(XJCollectionViewDataModel *)dataModel {
    [self insertDataModel:dataModel atSectionIndex:self.dataModels.count];
}

- (void)appendDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels
{
    for (XJCollectionViewDataModel *dataModel in dataModels) {
        [self appendDataModel:dataModel];
    }
}

#pragma mark - Insert dataModel

- (void)insertDataModel:(XJCollectionViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex
{
    if (!dataModel.header && !dataModel.rows.count) return;
    
    if (!self.dataModels) {
        self.dataModels = @[dataModel].mutableCopy;
        return;
    }
    
    [self registerCellWithData:@[dataModel]];

    if (sectionIndex > self.dataModels.count) {
        sectionIndex = self.dataModels.count;
    }
    
    [self.dataModels insertObject:dataModel atIndex:sectionIndex];

    [UIView performWithoutAnimation:^{
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    }];
}

- (void)insertDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels
          atSectionIndex:(NSInteger)sectionIndex
{
    NSArray *reverseDataModels = [[dataModels reverseObjectEnumerator] allObjects];
    for (XJCollectionViewDataModel *dataModel in reverseDataModels) {
        [self insertDataModel:dataModel atSectionIndex:sectionIndex];
    }
}

#pragma mark - Remove dataModel

- (void)removeSectionAtSectionIndex:(NSInteger)sectionIndex
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:sectionIndex];
    if (!dataModel) return;

    if ([self.dataModels containsObject:dataModel]) {
        [self.dataModels removeObject:dataModel];
        [self reloadData];
    }
}

- (void)removeCellAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (!cellModel) return;

    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    if ([dataModel.rows containsObject:cellModel]) {
        [dataModel.rows removeObject:cellModel];
        [self reloadData];
    }
}

- (void)removeHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    dataModel.header = nil;
    [self reloadData];
}

- (void)removeFooterAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    dataModel.footer = nil;
    [self reloadData];
}

- (void)removeAllDataModels
{
    [self.dataModels removeAllObjects];
    [self reloadData];
}

#pragma mark - Get dataModel

- (NSArray *)allDataModels {
    return self.dataModels;
}

- (nullable XJCollectionViewDataModel *)dataModelAtSectionIndex:(NSInteger)sectionIndex
{
    if (sectionIndex < 0 || sectionIndex >= self.dataModels.count) {
        return nil;
    }
    XJCollectionViewDataModel *dataModel = [self.dataModels objectAtIndex:sectionIndex];
    return dataModel;
}

- (nullable XJCollectionViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    if (indexPath.row < 0 || indexPath.row >= dataModel.rows.count) {
        return nil;
    }

    XJCollectionViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel;
}

- (nullable XJCollectionViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    return dataModel.header;
}

- (nullable XJCollectionViewFooterModel *)footerModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    return dataModel.footer;
}

- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath
{
    XJCollectionReusableModel *headerModel = [self headerModelAtIndexPath:indexPath];
    return headerModel.sectionId;
}

#pragma mark - Update cellModel, header, footer

- (void)updateCellModelAtIndexPath:(NSIndexPath *)indexPath
              updateCellModelBlock:(XJCollectionViewCellModel * _Nullable (^)(XJCollectionViewCellModel * _Nullable cellModel))cellModelBlock
{
    if (!cellModelBlock) return;

    XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    XJCollectionViewCellModel *returnCellModel = cellModelBlock(cellModel);
    if (returnCellModel) {
        [self reloadData];
    }
}

- (void)updateCellModelsAtIndexPaths:(NSArray *)indexPaths
               updateCellModelsBlock:(NSArray * _Nullable (^)(NSArray * _Nullable cellModels))cellModelsBlock
{
    NSMutableArray *cellModels = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths)
    {
        XJCollectionViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        [cellModels addObject:cellModel];
    }

    NSArray *returnCellModels = cellModelsBlock(cellModels);
    if (returnCellModels && indexPaths) {
        [self reloadData];
    }
}

- (void)updateHeaderModelAtIndexPath:(NSIndexPath *)indexPath
              updateHeaderModelBlock:(XJCollectionViewHeaderModel * _Nullable (^)(XJCollectionViewHeaderModel * _Nullable headerModel))headerModelBlock;
{
    if (!headerModelBlock) return;

    XJCollectionViewHeaderModel *headerModel = [self headerModelAtIndexPath:indexPath];
    XJCollectionViewHeaderModel *returnHeaderModel = headerModelBlock(headerModel);
    if (returnHeaderModel) {
        [self reloadData];
    }
}

- (void)updateFooterModelAtIndexPath:(NSIndexPath *)indexPath
              updateFooterModelBlock:(XJCollectionViewFooterModel * _Nullable (^)(XJCollectionViewFooterModel * _Nullable footerModel))footerModelBlock;
{
    if (!footerModelBlock) return;

    XJCollectionViewFooterModel *footerModel = [self footerModelAtIndexPath:indexPath];
    XJCollectionViewFooterModel *returnFooterModel = footerModelBlock(footerModel);
    if (returnFooterModel) {
        [self reloadData];
    }
}

#pragma mark - Register cell

- (void)registerCellWithData:(NSArray *)data
{
    for (XJCollectionViewDataModel *dataModel in data)
    {
        NSString *headerReusableId = dataModel.header.identifier;
        if (headerReusableId.length)
        {
            if (![self.registeredCells valueForKey:headerReusableId])
            {
                [self.registeredCells setValue:headerReusableId forKey:headerReusableId];
                NSString *kind = UICollectionElementKindSectionHeader;

                Class class = NSClassFromString(headerReusableId);
                NSBundle *bundle = [NSBundle bundleForClass:class];
                if([bundle pathForResource:headerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:headerReusableId bundle:bundle];
                    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:headerReusableId];
                }
                else
                {
                    [self registerClass:class forSupplementaryViewOfKind:kind withReuseIdentifier:headerReusableId];
                }
            }
        }

        NSString *footerReusableId = dataModel.footer.identifier;
        if (footerReusableId.length)
        {
            if (![self.registeredCells valueForKey:footerReusableId])
            {
                [self.registeredCells setValue:footerReusableId forKey:footerReusableId];
                NSString *kind = UICollectionElementKindSectionFooter;

                Class class = NSClassFromString(footerReusableId);
                NSBundle *bundle = [NSBundle bundleForClass:class];
                if([bundle pathForResource:footerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:footerReusableId bundle:bundle];
                    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:footerReusableId];
                }
                else
                {
                    [self registerClass:class forSupplementaryViewOfKind:kind withReuseIdentifier:footerReusableId];
                }
            }
        }

        if (dataModel.rows)
        {
            for (XJCollectionViewCellModel *cellModel in dataModel.rows)
            {
                NSString *cellId = cellModel.identifier;
                if ([self.registeredCells valueForKey:cellId]) continue;
                [self.registeredCells setValue:cellId forKey:cellId];

                Class class = NSClassFromString(cellId);
                NSBundle *bundle = [NSBundle bundleForClass:class];
                if([bundle pathForResource:cellId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:cellId bundle:bundle];
                    [self registerNib:nib forCellWithReuseIdentifier:cellId];
                }
                else
                {
                    [self registerClass:class forCellWithReuseIdentifier:cellId];
                }
            }
        }
    }
}

#pragma mark - Add block

- (void)addCellForItemBlock:(XJCollectionViewCellForItemBlock)itemBlock {
    self.cellForItemBlock = itemBlock;
}

- (void)addWillDisplayCellBlock:(XJCollectionViewWillDisplayCellBlock)cellBlock {
    self.willDisplayCellBlock = cellBlock;
}

- (void)addDidSelectItemBlock:(XJCollectionViewDidSelectItemBlock)itemBlock {
    self.didSelectItemBlock = itemBlock;
}

- (void)addViewForSupplementaryElementBlock:(XJCollectionViewForSupplementaryElementBlock)supplementaryElementBlock {
    self.viewForSupplementaryElementBlock = supplementaryElementBlock;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollViewWillBeginDraggingBlock) {
        self.scrollViewWillBeginDraggingBlock(scrollView);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollViewDidEndDeceleratingBlock) {
        self.scrollViewDidEndDeceleratingBlock(scrollView);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollViewDidEndDraggingBlock) {
        self.scrollViewDidEndDraggingBlock(scrollView, decelerate);
    }
}

@end
