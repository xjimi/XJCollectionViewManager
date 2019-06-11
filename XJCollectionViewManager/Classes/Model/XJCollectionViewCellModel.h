//
//  XJCollectionViewCellModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XJCollectionViewCellModel : NSObject

@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong, nullable) id data;

+ (nonnull XJCollectionViewCellModel *)modelWithReuseIdentifier:(nullable NSString *)identifier
                                                           size:(CGSize)size
                                                           data:(nullable id)data;

@end
