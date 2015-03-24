//
//  PSNetworkVC.m
//  VLC for iOS
//
//  Created by DongYiming on 15/3/20.
//  Copyright (c) 2015年 VideoLAN. All rights reserved.
//

#import "PSNetworkVC.h"
#import "PSNetworkOptionCollectionCell.h"

#define GAP    (10)

@interface PSNetworkVC () <UICollectionViewDataSource, UICollectionViewDelegate> {
    UICollectionView    *_collectionView;
    
    NSArray             *_titles;
    NSArray             *_images;
}

@end

@implementation PSNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Network";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize viewSize = self.view.bounds.size;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(viewSize.width * 0.5 - 2 * GAP, 150);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = GAP;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    ///
    [_collectionView registerClass:[PSNetworkOptionCollectionCell class] forCellWithReuseIdentifier:@"optionCell"];
    
    ///
    _titles = @[@"Network", @"Download", @"Wifi", @"Cloud"];
    _images = @[@"network_option_local", @"network_option_down", @"network_option_wifi", @"network_option_cloud"];
}

#pragma mark - collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSNetworkOptionCollectionCell *cell = (PSNetworkOptionCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"optionCell" forIndexPath:indexPath];
    
    cell.labelTitle.text = _titles[indexPath.row];
    cell.imageviewLogo.image = [UIImage imageNamed:_images[indexPath.row]];
    
    return cell;
}


@end
