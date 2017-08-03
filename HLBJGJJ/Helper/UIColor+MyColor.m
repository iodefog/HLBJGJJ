//
//  UIColor+mycolor.m
//  iOSMaps
//
//  Created by Hongli li on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "UIColor+MyColor.h"

@implementation UIColor(MyColor)

+(UIColor *) colorWithButtonHighLight{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
}

+(UIColor *)colorWithBlueHighLight{
    return [UIColor colorWithRed:82 / 255.0 green:135 /255.0 blue:238 /255.0 alpha:1];
}

+(UIColor *)colorWithRed:(int)r greed:(int)g blue:(int)b{
    return [UIColor colorWithRed:r / 255.0 green:g /255.0 blue:b /255.0 alpha:1];
}

@end
