//
//  XJCollectionViewReusableView.h
//  Vidol
//
//  Created by XJIMI on 2015/10/19.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJCollectionReusableView : UICollectionReusableView

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
