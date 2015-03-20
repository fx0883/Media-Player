//
//  PSNetworkVC.m
//  VLC for iOS
//
//  Created by DongYiming on 15/3/20.
//  Copyright (c) 2015年 VideoLAN. All rights reserved.
//

#import "PSNetworkVC.h"

#define GAP    (10)

@interface PSNetworkVC () <UICollectionViewDataSource, UICollectionViewDelegate> {
    UICollectionView    *_collectionView;
}

@end

@implementation PSNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Network";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize viewSize = self.view.bounds.size;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(viewSize.width * 0.5 - 1.5 * GAP, 150);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = GAP;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

#pragma mark - collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}


@end
