//
//  DramaModel.h
//  XJCollectionViewManager_Example
//
//  Created by XJIMI on 2019/6/11.
//  Copyright © 2019 xjimi. All rights reserved.
//

#import <XJCollectionViewManager/XJCollectionViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface DramaModel : XJCollectionViewCellModel

@property (nonatomic, copy) NSString *coverImageName;

@property (nonatomic, copy) NSString *dramaName;

@property (nonatomic, copy) NSString *detailInfo;

@end

NS_ASSUME_NONNULL_END
