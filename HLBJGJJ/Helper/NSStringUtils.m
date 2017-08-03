//
//  NSStringUtils.m
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/30.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "NSStringUtils.h"

@implementation NSStringUtils

+(BOOL)isEmpty:(NSString *)string{
    if (string == nil || [string isEqualToString:string]) {
        return YES;
    }
    return NO;
}
@end
