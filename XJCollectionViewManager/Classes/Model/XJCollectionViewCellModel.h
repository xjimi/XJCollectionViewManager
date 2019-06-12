//
//  XJCollectionViewCellModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewCellModel : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong, nullable) id data;

+ (XJCollectionViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                   size:(CGSize)size
                                                   data:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
