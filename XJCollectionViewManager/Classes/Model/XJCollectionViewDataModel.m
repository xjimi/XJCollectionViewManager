//
//  XJCollectionViewDataModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewDataModel.h"

@implementation XJCollectionViewDataModel

+ (nonnull XJCollectionViewDataModel *)modelWithSection:(nullable XJCollectionReusableModel *)reusableModel
                                                   rows:(nonnull NSArray *)rows
{
    XJCollectionViewDataModel *dataModel = [[XJCollectionViewDataModel alloc] init];
    dataModel.section = reusableModel;
    dataModel.rows = rows.mutableCopy;
    return dataModel;
}

@end
