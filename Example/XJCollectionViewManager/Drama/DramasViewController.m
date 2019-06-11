//
//  AlbumsViewController.m
//  XJCollectionViewManager_Example
//
//  Created by XJIMI on 2019/6/10.
//  Copyright © 2019 xjimi. All rights reserved.
//

#import "DramasViewController.h"
#import <XJCollectionViewManager/XJCollectionViewManager.h>
#import <Masonry/Masonry.h>
#import "DramaHeader.h"
#import "DramaCell.h"

@interface DramasViewController ()

@property (nonatomic, strong) XJCollectionViewManager *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@end

@implementation DramasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createCollectionView];
    [self reloadData];
}

#pragma mark - Create XJCollectionView and dataModel

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 3;
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 3, 0);
    
    XJCollectionViewManager *collectionView = [XJCollectionViewManager managerWithCollectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.controlsView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    self.collectionView = collectionView;
}

- (void)reloadData {
    self.collectionView.data = @[[self createDataModel]].mutableCopy;
}

- (XJCollectionViewDataModel *)createDataModel
{
    XJCollectionViewDataModel *dataModel = [XJCollectionViewDataModel
                                            modelWithSection:[self createHeaderModel]
                                            rows:[self createRows]];
    return dataModel;
}

- (XJCollectionReusableModel *)createHeaderModel
{
    NSString *setion = [NSString stringWithFormat:@"New Drama %ld", (long)self.collectionView.data.count + 1];
    CGFloat vw = CGRectGetWidth(self.view.frame);
    XJCollectionReusableModel *headerModel = [XJCollectionReusableModel
                                              modelWithReuseIdentifier:[DramaHeader identifier]
                                              size:CGSizeMake(vw, 50)
                                              data:setion];
    return headerModel;
}

- (NSMutableArray *)createRows
{
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < 9; i++)
    {
        DramaModel *model = [[DramaModel alloc] init];
        model.dramaName = @"Signal";
        model.detailInfo = @"tvN Korean Drama of 2018";
        model.imageName = @"drama";

        CGFloat vw = (CGRectGetWidth(self.view.frame) * .5) - 1.5;
        CGFloat cellh = roundf(vw * (9.0 / 16.0)) + 70;
        XJCollectionViewCellModel *cellModel = [XJCollectionViewCellModel
                                                modelWithReuseIdentifier:[DramaCell identifier]
                                                size:CGSizeMake(vw, cellh)
                                                data:model];
        [rows addObject:cellModel];
    }
    return rows;
}

#pragma mark - Controls Action

- (IBAction)action_appendRows
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJCollectionReusableModel *section = nil;
        if (sectionIndex < self.collectionView.data.count)
        {
            XJCollectionViewDataModel *dataModel = [self.collectionView.data objectAtIndex:sectionIndex];
            section = dataModel.section;
        }
        
        XJCollectionViewDataModel *newDataModel = [XJCollectionViewDataModel
                                                   modelWithSection:section
                                                   rows:[self createRows]];
        [self.collectionView appendRowsWithDataModel:newDataModel];
        
    });
}

- (IBAction)action_appendDataModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJCollectionViewDataModel *newDataModel = [XJCollectionViewDataModel
                                                   modelWithSection:nil
                                                   rows:[self createRows]];
        [self.collectionView appendDataModel:newDataModel];
        
    });
}

- (IBAction)action_insertSection
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJCollectionViewDataModel *dataModel = [self createDataModel];
        [self.collectionView insertDataModel:dataModel atSectionIndex:sectionIndex];
        
    });
}


@end
