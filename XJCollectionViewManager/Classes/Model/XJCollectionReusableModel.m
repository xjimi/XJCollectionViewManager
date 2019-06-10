//
//  XJCollectionViewReusableModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJCollectionReusableModel.h"

@implementation XJCollectionReusableModel

+ (XJCollectionReusableModel *)modelData {
    return [XJCollectionReusableModel modelWithReuseIdentifier:nil size:CGSizeZero data:nil];
}

+ (XJCollectionReusableModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                   size:(CGSize)size
                                                   data:(id)data
{
    return [XJCollectionReusableModel modelWithReuseIdentifier:identifier size:size data:data delegate:nil];
}

+ (XJCollectionReusableModel *)modelWithReuseIdentifier:(NSString *)identifier
                                                   size:(CGSize)size
                                                   data:(id)data
                                               delegate:(id)delegate;
{
    XJCollectionReusableModel *headerModel = [[XJCollectionReusableModel alloc] init];
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    identifier = identifier ? : @"EmptyHeader";
    headerModel.sectionId = [NSString stringWithFormat:@"%@_%ld", identifier, (long)time];
    headerModel.identifier = identifier;
    headerModel.size = size;
    headerModel.data = data;
    return headerModel;
}

@end
