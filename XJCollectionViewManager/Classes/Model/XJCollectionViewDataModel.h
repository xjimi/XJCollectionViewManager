//
//  XJCollectionViewDataModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJCollectionViewHeaderModel.h"
#import "XJCollectionViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewDataModel : NSObject

@property (nonatomic, strong, nullable) XJCollectionReusableModel *section;
@property (nonatomic, strong) NSMutableArray *rows;

+ (XJCollectionViewDataModel *)modelWithSection:(nullable XJCollectionReusableModel *)reusableModel
                                           rows:(NSArray *)rows;
@end

NS_ASSUME_NONNULL_END
