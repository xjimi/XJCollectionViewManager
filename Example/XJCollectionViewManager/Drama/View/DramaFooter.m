//
//  DramaFooter.m
//  XJCollectionViewManager_Example
//
//  Created by XJIMI on 2020/1/7.
//  Copyright © 2020 xjimi. All rights reserved.
//

#import "DramaFooter.h"

@implementation DramaFooter

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

@end
