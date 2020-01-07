//
//  XJCollectionViewHeaderModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionReusableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewHeaderModel : XJCollectionReusableModel

+ (XJCollectionViewHeaderModel *)emptyModel;

+ (XJCollectionViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data;

+ (XJCollectionViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                     size:(CGSize)size
                                                     data:(nullable id)data
                                                 delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
