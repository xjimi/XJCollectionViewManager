//
//  XJCollectionViewReusableModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionReusableModel : NSObject

@property (nonatomic, copy, readonly) NSString *sectionId;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, weak, nullable) id delegate;

+ (XJCollectionReusableModel *)emptyModel;

+ (XJCollectionReusableModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                   size:(CGSize)size
                                                   data:(nullable id)data;

+ (XJCollectionReusableModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                   size:(CGSize)size
                                                   data:(nullable id)data
                                               delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
