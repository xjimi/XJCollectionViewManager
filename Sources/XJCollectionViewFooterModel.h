//
//  XJCollectionViewFooterModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionReusableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewFooterModel : XJCollectionReusableModel

+ (XJCollectionViewFooterModel *)emptyModel;

+ (XJCollectionViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data;

+ (XJCollectionViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data
                                                 delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
