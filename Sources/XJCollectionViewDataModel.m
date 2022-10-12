//
//  XJCollectionViewDataModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewDataModel.h"

@implementation XJCollectionViewDataModel

+ (XJCollectionViewDataModel *)modelWithHeader:(nullable XJCollectionViewHeaderModel *)headerModel
                                          rows:(NSArray *)rows {
    return [XJCollectionViewDataModel modelWithHeader:headerModel footer:nil rows:rows];
}

+ (XJCollectionViewDataModel *)modelWithFooter:(nullable XJCollectionViewFooterModel *)footerModel
                                          rows:(NSArray *)rows {
    return [XJCollectionViewDataModel modelWithHeader:nil footer:footerModel rows:rows];
}

+ (XJCollectionViewDataModel *)modelWithHeader:(nullable XJCollectionViewHeaderModel *)headerModel
                                        footer:(nullable XJCollectionViewFooterModel *)footerModel
                                          rows:(NSArray *)rows
{
    XJCollectionViewDataModel *dataModel = [[XJCollectionViewDataModel alloc] init];
    dataModel.header = headerModel ? : [XJCollectionViewHeaderModel emptyModel];
    dataModel.footer = footerModel;
    dataModel.rows = rows.mutableCopy;
    return dataModel;
}


@end
