//
//  XJCollectionViewReusableModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XJCollectionReusableModel : NSObject

@property (nonatomic, copy, nonnull) NSString *sectionId;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, weak, nullable) id delegate;

+ (nonnull XJCollectionReusableModel *)modelWithReuseIdentifier:(nullable NSString *)identifier
                                                           size:(CGSize)size
                                                           data:(nullable id)data;

+ (nonnull XJCollectionReusableModel *)modelWithReuseIdentifier:(nullable NSString *)identifier
                                                           size:(CGSize)size
                                                           data:(nullable id)data
                                                       delegate:(nullable id)delegate;

@end