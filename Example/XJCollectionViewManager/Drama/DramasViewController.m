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
#import "DramaFooter.h"
#import "DramaCell.h"

@interface DramasViewController () <UIScrollViewDelegate>

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
    collectionView.scrollViewDelegate = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.controlsView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    self.collectionView = collectionView;

    __weak typeof(self)weakSelf = self;
    [self.collectionView addDidSelectItemBlock:^(XJCollectionViewCellModel * _Nonnull cellModel, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.collectionView removeFooterAtIndexPath:indexPath];
    }];

    [self.collectionView setScrollViewDidScrollBlock:^(UIScrollView * _Nonnull scrollView) {
//        NSLog(@"scrollViewDidScroll---- ++++");
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll----");
}

- (void)reloadData {
    [self.collectionView refreshDataModel:[self createDataModelWithIndex:0]];
}

- (XJCollectionViewDataModel *)createDataModelWithIndex:(NSInteger)index
{
    XJCollectionViewDataModel *dataModel = [XJCollectionViewDataModel
                                            modelWithHeader:[self createHeaderModelWithIndex:index]
                                            footer:[self createFooterModelWithIndex:index]
                                            rows:[self createRows]];
    return dataModel;
}

- (XJCollectionViewHeaderModel *)createHeaderModelWithIndex:(NSInteger)index
{
    NSString *setion = [NSString stringWithFormat:@"New Drama %ld", (long)self.collectionView.allDataModels.count + index];
    CGFloat vw = CGRectGetWidth(self.view.frame);
    XJCollectionViewHeaderModel *headerModel = [XJCollectionViewHeaderModel
                                                modelWithReuseIdentifier:[DramaHeader identifier]
                                                size:CGSizeMake(vw, 50)
                                                data:setion];
    return headerModel;
}

- (XJCollectionViewFooterModel *)createFooterModelWithIndex:(NSInteger)index
{
    NSString *setion = [NSString stringWithFormat:@"footer %ld", (long)self.collectionView.allDataModels.count + index];
    CGFloat vw = CGRectGetWidth(self.view.frame);
    XJCollectionViewFooterModel *footerModel = [XJCollectionViewFooterModel
                                                modelWithReuseIdentifier:[DramaFooter identifier]
                                                size:CGSizeMake(vw, 50)
                                                data:setion];
    return footerModel;
}

- (NSMutableArray *)createRows
{
    NSMutableArray *rows = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++)
    {
        DramaModel *model = [[DramaModel alloc] init];
        model.dramaName = [NSString stringWithFormat:@"%ld Signal", i];
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
        
        XJCollectionViewHeaderModel *header = nil;
        if (sectionIndex < self.collectionView.allDataModels.count)
        {
            XJCollectionViewDataModel *dataModel = [self.collectionView.allDataModels objectAtIndex:sectionIndex];
            header = dataModel.header;
        }
        
        XJCollectionViewDataModel *newDataModel = [XJCollectionViewDataModel
                                                   modelWithHeader:header
                                                   rows:[self createRows]];
        [self.collectionView appendRowsWithDataModel:newDataModel];
        
    });
}

- (IBAction)action_appendDataModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJCollectionViewDataModel *newDataModel = [XJCollectionViewDataModel
                                                   modelWithHeader:nil
                                                   rows:[self createRows]];
        [self.collectionView appendDataModel:newDataModel];
        
    });
}

- (IBAction)action_appendDataModels
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSMutableArray *dataModels = [NSMutableArray array];
        for (NSInteger i = 0 ; i < 3; i ++)
        {
            XJCollectionViewDataModel *dataModel = [self createDataModelWithIndex:i];
            [dataModels addObject:dataModel];
        }
        [self.collectionView appendDataModels:dataModels];

    });
}

- (IBAction)action_insertSection
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJCollectionViewDataModel *dataModel = [self createDataModelWithIndex:0];
        [self.collectionView insertDataModel:dataModel atSectionIndex:sectionIndex];
        
    });
}


@end
