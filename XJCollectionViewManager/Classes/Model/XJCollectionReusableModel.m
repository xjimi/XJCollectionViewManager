//
//  XJCollectionViewReusableModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionReusableModel.h"

@implementation XJCollectionReusableModel

+ (nonnull XJCollectionReusableModel *)modelWithReuseIdentifier:(nullable NSString *)identifier
                                                           size:(CGSize)size
                                                           data:(nullable id)data
{
    return [XJCollectionReusableModel modelWithReuseIdentifier:identifier size:size data:data delegate:nil];
}

+ (nonnull XJCollectionReusableModel *)modelWithReuseIdentifier:(nullable NSString *)identifier
                                                           size:(CGSize)size
                                                           data:(nullable id)data
                                                       delegate:(nullable id)delegate;
{
    XJCollectionReusableModel *reusableModel = [[XJCollectionReusableModel alloc] init];
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    identifier = identifier ? : @"EmptyHeader";
    reusableModel.sectionId = [NSString stringWithFormat:@"%@_%ld", identifier, (long)time];
    reusableModel.identifier = identifier;
    reusableModel.size = size;
    reusableModel.data = data;
    reusableModel.delegate = delegate;
    return reusableModel;
}

@end
