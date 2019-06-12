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

@property (nonatomic, strong, nullable) NSMutableArray *data;

+ (instancetype)managerWithCollectionViewLayout:(UICollectionViewLayout *)layout;

- (void)addViewForSupplementaryElementBlock:(XJCollectionViewForSupplementaryElementBlock)supplementaryElementBlock;
- (void)addCellForItemBlock:(XJCollectionViewCellForItemBlock)itemBlock;
- (void)addWillDisplayCellBlock:(XJCollectionViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectItemBlock:(XJCollectionViewDidSelectItemBlock)itemBlock;

- (void)appendDataModel:(XJCollectionViewDataModel *)dataModel;
- (void)appendRowsWithDataModel:(XJCollectionViewDataModel *)dataModel;
- (void)insertDataModel:(XJCollectionViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex;

- (nullable XJCollectionViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable XJCollectionReusableModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
