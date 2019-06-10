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
    self.tableView.data = @[[self createDataModel]].mutableCopy;
}

- (XJCollectionViewDataModel *)createDataModel
{
    XJCollectionViewDataModel *dataModel = [XJCollectionViewDataModel
                                            modelWithSection:[self createHeaderModel]
                                            rows:[self createRows]];
    return dataModel;
}

- (XJCollectionViewHeaderModel *)createHeaderModel
{
    NSString *setion = [NSString stringWithFormat:@"New Album %ld", (long)self.collectionView.data.count];
    XJTableViewHeaderModel *headerModel = [XJTableViewHeaderModel
                                           modelWithReuseIdentifier:[AlbumHeader identifier]
                                           headerHeight:50.0f
                                           data:setion];
    return headerModel;
}

- (NSMutableArray *)createRows
{
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        AlbumModel *model = [[AlbumModel alloc] init];
        model.albumName = @"Scorpion (OVO Updated Version) [iTunes][2018]";
        model.artistName = @"Drake";
        model.imageName = @"drake";
        
        XJTableViewCellModel *cellModel = [XJTableViewCellModel
                                           modelWithReuseIdentifier:[AlbumCell identifier]
                                           cellHeight:80.0f
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
        
        XJTableViewHeaderModel *section = nil;
        if (sectionIndex < self.tableView.data.count)
        {
            XJTableViewDataModel *dataModel = [self.tableView.data objectAtIndex:sectionIndex];
            section = dataModel.section;
        }
        
        XJTableViewDataModel *newDataModel = [XJTableViewDataModel
                                              modelWithSection:section
                                              rows:[self createRows]];
        [self.tableView appendRowsWithDataModel:newDataModel];
        
    });
}

- (IBAction)action_appendDataModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJTableViewDataModel *newDataModel = [XJTableViewDataModel
                                              modelWithSection:nil
                                              rows:[self createRows]];
        [self.tableView appendDataModel:newDataModel];
        
    });
}

- (IBAction)action_insertSection
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJTableViewDataModel *dataModel = [self createDataModel];
        [self.tableView insertDataModel:dataModel atSectionIndex:sectionIndex];
        
    });
}


@end
