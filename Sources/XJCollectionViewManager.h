//
//  XJCollectionViewManager.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XJCollectionViewDelegate.h"
#import "XJCollectionViewDataModel.h"
#import "XJCollectionViewHeaderModel.h"
#import "XJCollectionViewFooterModel.h"
#import "XJCollectionViewCellModel.h"
#import "XJCollectionViewHeader.h"
#import "XJCollectionViewFooter.h"
#import "XJCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^XJCollectionViewForSupplementaryElementBlock) (NSString * kind, XJCollectionReusableModel * reusableModel, XJCollectionReusableView * reusableView, NSIndexPath * indexPath);

typedef void (^XJCollectionViewCellForItemBlock) (XJCollectionViewCellModel * cellModel, XJCollectionViewCell * cell, NSIndexPath * indexPath);

typedef void (^XJCollectionViewWillDisplayCellBlock) (XJCollectionViewCellModel * cellModel, XJCollectionViewCell * cell, NSIndexPath * indexPath);

typedef void (^XJCollectionViewDidSelectItemBlock) (XJCollectionViewCellModel * cellModel, NSIndexPath * indexPath);

@interface XJCollectionViewManager : UICollectionView

@property (nonatomic, weak, nullable) id < XJCollectionViewDelegate > collectionViewDelegate;
@property (nonatomic, weak, nullable) id < UIScrollViewDelegate > scrollViewDelegate;

@property (nonatomic, copy) void (^scrollViewDidScrollBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^scrollViewWillBeginDraggingBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^scrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^scrollViewDidEndDraggingBlock)(UIScrollView *scrollView, BOOL decelerate);
@property (nonatomic, copy) void (^scrollViewDidScrollToTopBlock)(UIScrollView *scrollView);

+ (instancetype)managerWithCollectionViewLayout:(UICollectionViewLayout *)layout;

#pragma mark - Refresh dataModel

/// 刷新 dataModel
/// @param dataModel 待更新的 dataModel
- (void)refreshDataModel:(XJCollectionViewDataModel *)dataModel;

/// 刷新多組 dataModel
/// @param dataModels 待更新的 dataModels
- (void)refreshDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels;

#pragma mark - Append dataModel

/// 添加1組 dataModel (包含 header, footer, cell)
/// @param dataModel 添加的 dataModel 資料
- (void)appendDataModel:(XJCollectionViewDataModel *)dataModel;

/// 添加多組 dataModel (包含 header, footer, cell)
/// @param dataModels 添加多組的 dataModel 資料
- (void)appendDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels;

/// 添加1組 dataModel 的 rows (只包含 cell)
/// @param dataModel 添加的 dataModel 資料
- (void)appendRowsWithDataModel:(XJCollectionViewDataModel *)dataModel;

#pragma mark - Insert dataModel

/// 插入1組 dataModel (包含 header, footer, cell)
/// @param dataModel  插入的 dataModel 資料
/// @param sectionIndex  插入的索引位置
- (void)insertDataModel:(XJCollectionViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex;


/// 插入多組 dataModel (包含 header, footer, cell)
/// @param dataModels 插入多組的 dataModel 資料
/// @param sectionIndex 插入的索引位置
- (void)insertDataModels:(NSArray <XJCollectionViewDataModel *> *)dataModels
          atSectionIndex:(NSInteger)sectionIndex;


#pragma mark - Remove dataModel

/// 移除 section 整個區塊，包含 header, footer, cell
/// @param sectionIndex 待刪除的索引位置
- (void)removeSectionAtSectionIndex:(NSInteger)sectionIndex;

/// 移除 cell 區塊
/// @param indexPath 待刪除的索引位置
- (void)removeCellAtIndexPath:(NSIndexPath *)indexPath;

/// 移除 header 區塊
/// @param indexPath 待刪除的索引位置
- (void)removeHeaderAtIndexPath:(NSIndexPath *)indexPath;

/// 移除 footer 區塊
/// @param indexPath 待刪除的索引位置
- (void)removeFooterAtIndexPath:(NSIndexPath *)indexPath;

/// 移除所有 dataModel
- (void)removeAllDataModels;

#pragma mark - Update cellModel, header, footer


/// 更新1個 cellModel
/// @param indexPath 待更新的索引位置
/// @param cellModelBlock 更新 cellModel 的 block
- (void)updateCellModelAtIndexPath:(NSIndexPath *)indexPath
              updateCellModelBlock:(XJCollectionViewCellModel * _Nullable (^)(XJCollectionViewCellModel * _Nullable cellModel))cellModelBlock;

/// 更新多個 cellModel
/// @param indexPaths 待更新的多個索引位置
/// @param cellModelsBlock 更新 cellModel 的 block
- (void)updateCellModelsAtIndexPaths:(NSArray *)indexPaths
               updateCellModelsBlock:(NSArray * _Nullable (^)(NSArray * _Nullable cellModels))cellModelsBlock;

/// 更新 headerModel
/// @param indexPath 待更新的索引位置
/// @param headerModelBlock 更新 headerModel 的 block
- (void)updateHeaderModelAtIndexPath:(NSIndexPath *)indexPath
              updateHeaderModelBlock:(XJCollectionViewHeaderModel * _Nullable (^)(XJCollectionViewHeaderModel * _Nullable headerModel))headerModelBlock;

/// 更新 footerModel
/// @param indexPath 待更新的索引位置
/// @param footerModelBlock 更新 footerModel 的 block
- (void)updateFooterModelAtIndexPath:(NSIndexPath *)indexPath
              updateFooterModelBlock:(XJCollectionViewFooterModel * _Nullable (^)(XJCollectionViewFooterModel * _Nullable footerModel))footerModelBlock;


#pragma mark - Get dataModel

/// 取得所有 dataModels
- (NSArray *)allDataModels;

/// 取得特定的 dataModel
/// @param sectionIndex 欲取得的索引位置
- (nullable XJCollectionViewDataModel *)dataModelAtSectionIndex:(NSInteger)sectionIndex;

/// 取得特定的 cellModel
/// @param indexPath 欲取得的索引位置
- (nullable XJCollectionViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;

/// 取得特定的 headerModel
/// @param indexPath 欲取得的索引位置
- (nullable XJCollectionViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath;

/// 取得特定的 footerModel
/// @param indexPath 欲取得的索引位置
- (nullable XJCollectionViewFooterModel *)footerModelAtIndexPath:(NSIndexPath *)indexPath;

/// 取得特定的 sessionId
/// @param indexPath 欲取得的索引位置
- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Add block

- (void)addCellForItemBlock:(XJCollectionViewCellForItemBlock)itemBlock;
- (void)addWillDisplayCellBlock:(XJCollectionViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectItemBlock:(XJCollectionViewDidSelectItemBlock)itemBlock;
- (void)addViewForSupplementaryElementBlock:(XJCollectionViewForSupplementaryElementBlock)supplementaryElementBlock;

@end

NS_ASSUME_NONNULL_END
