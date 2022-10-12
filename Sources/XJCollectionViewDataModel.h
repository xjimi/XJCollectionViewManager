//
//  XJCollectionViewDataModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJCollectionViewHeaderModel.h"
#import "XJCollectionViewFooterModel.h"
#import "XJCollectionViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewDataModel : NSObject

@property (nonatomic, strong, nullable) XJCollectionViewHeaderModel *header;
@property (nonatomic, strong, nullable) XJCollectionViewFooterModel *footer;
@property (nonatomic, strong) NSMutableArray *rows;

+ (XJCollectionViewDataModel *)modelWithHeader:(nullable XJCollectionViewHeaderModel *)headerModel
                                          rows:(NSArray *)rows;

+ (XJCollectionViewDataModel *)modelWithFooter:(nullable XJCollectionViewFooterModel *)footerModel
                                          rows:(NSArray *)rows;

+ (XJCollectionViewDataModel *)modelWithHeader:(nullable XJCollectionViewHeaderModel *)headerModel
                                        footer:(nullable XJCollectionViewFooterModel *)footerModel
                                          rows:(NSArray *)rows;

@end

NS_ASSUME_NONNULL_END
