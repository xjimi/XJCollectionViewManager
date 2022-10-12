//
//  XJCollectionViewFooterModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewFooterModel.h"

@implementation XJCollectionViewFooterModel

+ (XJCollectionViewFooterModel *)emptyModel {
    return (XJCollectionViewFooterModel *)[XJCollectionViewFooterModel modelWithReuseIdentifier:@"EmptyFooter" size:CGSizeZero data:nil];
}

+ (XJCollectionViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data {
    return [XJCollectionViewFooterModel modelWithReuseIdentifier:identifier size:size data:data delegate:nil];
}

+ (XJCollectionViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data
                                                 delegate:(nullable id)delegate;
{
    XJCollectionViewFooterModel *footerModel = (XJCollectionViewFooterModel *)[XJCollectionReusableModel modelWithReuseIdentifier:identifier size:size data:data delegate:delegate];
    return footerModel;
}

@end
