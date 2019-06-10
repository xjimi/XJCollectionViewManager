//
//  DramaCell.m
//  XJCollectionViewManager_Example
//
//  Created by XJIMI on 2019/6/10.
//  Copyright © 2019 xjimi. All rights reserved.
//

#import "DramaCell.h"
#import "DramaModel.h"

@implementation DramaCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)reloadData:(id)data
{
    if ([data isKindOfClass:[DramaModel class]])
    {
        DramaModel *dramaModel = (DramaModel *)data;
        self.coverImageView.image = [UIImage imageNamed:dramaModel.coverImageName];
        self.titleLabel.text = dramaModel.dramaName;
        self.subtitleLabel.text = dramaModel.detailInfo;
    }
}

@end
