//
//  PSNetworkOptionCollectionCell.m
//  VLC for iOS
//
//  Created by DongYiming on 15/3/24.
//  Copyright (c) 2015年 VideoLAN. All rights reserved.
//

#import "PSNetworkOptionCollectionCell.h"
#import "Masonry.h"

@implementation PSNetworkOptionCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}


-(void)doInit {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    _imageviewLogo = [UIImageView new];
    _imageviewLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageviewLogo];
    [_imageviewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-10);
        make.width.equalTo(@33);
        make.height.equalTo(@33);
    }];
    
    _labelTitle = [UILabel new];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.font = [UIFont boldSystemFontOfSize:15];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelTitle];
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(_imageviewLogo.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:highlighted ? 0.9 : 0.98 alpha:1];
}

@end
