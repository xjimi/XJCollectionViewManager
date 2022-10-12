//
//  XJCollectionViewCell.h
//  Vidol
//
//  Created by XJIMI on 2015/10/6.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionViewCell : UICollectionViewCell

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
