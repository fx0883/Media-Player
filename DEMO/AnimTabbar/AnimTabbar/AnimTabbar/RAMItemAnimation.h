//
//  DRAMItemAnimation.h
//  AnimTabbar
//
//  Created by D. D. on 3/11/15.
//  Copyright (c) 2015 DongYiming. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol RAMItemAnimationProtocol

-(void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel;
-(void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor;
-(void)selectState:(UIImageView *)icon textLabel:(UILabel *)textLabel;

@end


@interface RAMItemAnimation : NSObject <RAMItemAnimationProtocol>

@end
