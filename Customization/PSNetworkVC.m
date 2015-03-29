//
//  PSNetworkVC.m
//  VLC for iOS
//
//  Created by DongYiming on 15/3/20.
//  Copyright (c) 2015年 VideoLAN. All rights reserved.
//

#import "PSNetworkVC.h"
#import "PSNetworkOptionCollectionCell.h"
#import "VLCOpenNetworkStreamViewController.h"
#import "VLCLocalServerListViewController.h"
#import "VLCDownloadViewController.h"
#import "VLCCloudServicesTableViewController.h"


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
    self.navigationItem.title = NSLocalizedString(@"SECTION_HEADER_NETWORK", nil);
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
    _titles = @[NSLocalizedString(@"LOCAL_NETWORK", nil)
                , NSLocalizedString(@"DOWNLOAD_FROM_HTTP", nil)
                , NSLocalizedString(@"WEBINTF_TITLE", nil)
                , NSLocalizedString(@"Cloud Storages", nil)];
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        VLCLocalServerListViewController *vc = [VLCLocalServerListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        VLCDownloadViewController *vc = [[VLCDownloadViewController alloc] initWithNibName:@"VLCFutureDownloadViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        VLCCloudServicesTableViewController *vc = [[VLCCloudServicesTableViewController alloc] initWithNibName:@"VLCCloudServicesTableViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
