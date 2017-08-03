//
//  CommonUtils.m
//  iOSMaps
//
//  Created by Hongli li on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

/**
* 将UIColor变换为UIImage
*
**/
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NSInteger)readUserData:(NSString *)key{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

    NSUInteger value = [defaults integerForKey:key];
    
    return value;
}


+(void)writeUserData:(NSString *)key withValue:(NSInteger)value{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}



@end
