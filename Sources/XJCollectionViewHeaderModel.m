//
//  XJCollectionViewHeaderModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionViewHeaderModel.h"

@implementation XJCollectionViewHeaderModel

+ (XJCollectionViewHeaderModel *)emptyModel {
    return (XJCollectionViewHeaderModel *)[XJCollectionViewHeaderModel modelWithReuseIdentifier:@"EmptyHeader" size:CGSizeZero data:nil];
}

+ (XJCollectionViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data {
    return [XJCollectionViewHeaderModel modelWithReuseIdentifier:identifier size:size data:data delegate:nil];
}

+ (XJCollectionViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data
                                                 delegate:(nullable id)delegate;
{
    XJCollectionViewHeaderModel *headerModel = (XJCollectionViewHeaderModel *)[XJCollectionReusableModel modelWithReuseIdentifier:identifier size:size data:data delegate:delegate];
    return headerModel;
}

@end
