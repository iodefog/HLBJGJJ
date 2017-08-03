//
//  CommonUtils.h
//  iOSMaps
//
//  Created by Hongli li on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject

+(UIImage *)createImageWithColor:(UIColor *)color;

+(NSInteger) readUserData:(NSString *)key;

+(void) writeUserData:(NSString *)key withValue:(NSInteger) value;


@end
