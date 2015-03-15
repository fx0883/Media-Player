/*****************************************************************************
 * UIColor+Presets.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2014 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "UIColor+Presets.h"

@implementation UIColor (Presets)

+ (UIColor *)VLCDarkBackgroundColor
{
    return [UIColor colorWithWhite:1 alpha:1];
}

+ (UIColor *)VLCLightTextColor
{
    return [UIColor colorWithWhite:.72 alpha:1.];
}

+ (UIColor *)VLCDarkTextShadowColor
{
    return [UIColor colorWithWhite:0. alpha:.25f];
}

+ (UIColor *)VLCOrangeTintColor
{
    return [UIColor colorWithRed:(32/255.0) green:(106/255.0f) blue:(222/255.0) alpha:1.f];
}

@end
